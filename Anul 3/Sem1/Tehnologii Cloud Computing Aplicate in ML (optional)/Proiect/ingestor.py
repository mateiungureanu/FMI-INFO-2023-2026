import os
import json
import time
import logging
import signal
import threading
import shutil
import queue
from datetime import datetime
from typing import Optional
from watchdog.observers.polling import PollingObserver as Observer
from watchdog.events import FileSystemEventHandler, FileCreatedEvent, FileClosedEvent

# --- CONFIGURARE ---
INCOMING_DIR = "./incoming_logs"
PROCESSED_DIR = "./processed_logs"
FAILED_DIR = "./failed_logs"
AGGREGATED_FILE = "aggregated_errors.jsonl"
LOG_FILE = "ingestor.log"
SEARCH_KEYWORD = "CRITICAL"

# Configurare Logging Intern
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler(LOG_FILE, encoding='utf-8'),
        logging.StreamHandler()
    ]
)

class LogIngestor:
    def __init__(self):
        self.processing_queue: queue.Queue = queue.Queue()
        self.running = True
        self.file_lock = threading.Lock()

        # Asigurăm existența folderelor
        for directory in [INCOMING_DIR, PROCESSED_DIR, FAILED_DIR]:
            os.makedirs(directory, exist_ok=True)

    def _setup_signals(self):
        """Gestionează semnalele de oprire (SIGINT, SIGTERM)."""
        signal.signal(signal.SIGINT, self._handle_exit)
        signal.signal(signal.SIGTERM, self._handle_exit)

    def _handle_exit(self, signum, frame):
        logging.info(f"Semnal de oprire primit ({signum}). Se închide curat...")
        self.running = False

    def _process_single_file(self, file_path: str):
        """Logica principală de filtrare și agregare."""
        filename = os.path.basename(file_path)
        temp_results = []

        try:
            # Citire robustă (gestionăm caractere corupte cu errors='replace')
            with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
                for line_num, line in enumerate(f, 1):
                    if SEARCH_KEYWORD in line:
                        entry = {
                            "timestamp": datetime.now().isoformat(),
                            "source_file": filename,
                            "line_number": line_num,
                            "content": line.strip()
                        }
                        temp_results.append(entry)

            # Scriere atomică (cu lock) în JSONL
            if temp_results:
                with self.file_lock:
                    with open(AGGREGATED_FILE, 'a', encoding='utf-8') as out_f:
                        for item in temp_results:
                            out_f.write(json.dumps(item) + '\n')
                        out_f.flush()

            # Mutare în folderul de procesate
            shutil.move(file_path, os.path.join(PROCESSED_DIR, filename))
            logging.info(f"Succes: {filename} procesat ({len(temp_results)} linii gasite).")

        except Exception as e:
            logging.error(f"Eroare la procesarea fisierului {filename}: {str(e)}")
            try:
                shutil.move(file_path, os.path.join(FAILED_DIR, filename))
            except Exception as move_err:
                logging.critical(f"Nu s-a putut muta fisierul in failed_logs: {move_err}")

    def _worker(self):
        """Consumer Thread: Procesează fișierele din coadă."""
        while self.running or not self.processing_queue.empty():
            try:
                # Timeout scurt pentru a verifica periodic flag-ul self.running
                file_path = self.processing_queue.get(timeout=1)
                self._process_single_file(file_path)
                self.processing_queue.task_done()
            except queue.Empty:
                continue

    def _initial_scan(self):
        """Scanează folderul la pornire pentru fișiere lăsate în urmă."""
        logging.info("Scanare inițială a folderului incoming...")
        for entry in os.scandir(INCOMING_DIR):
            if entry.is_file():
                self.processing_queue.put(entry.path)

    def run(self):
        self._setup_signals()
        self._initial_scan()

        # Pornire Consumer Thread
        worker_thread = threading.Thread(target=self._worker)
        worker_thread.start()

        # Configurare Watchdog (Producer)
        event_handler = NewFileHandler(self.processing_queue)
        observer = Observer()
        observer.schedule(event_handler, INCOMING_DIR, recursive=False)
        observer.start()

        logging.info(f"Monitorizare activă pe {INCOMING_DIR}...")

        try:
            while self.running:
                time.sleep(1)
        finally:
            observer.stop()
            observer.join()
            worker_thread.join()
            logging.info("Ingestor oprit complet.")

class NewFileHandler(FileSystemEventHandler):
    def __init__(self, processing_queue: queue.Queue):
        self.processing_queue = processing_queue

    def on_any_event(self, event):
        """Prinde ABSOLUT ORICE se intampla in folder."""
        # Ignoram folderele, ne intereseaza doar fisierele
        if event.is_directory:
            return

        # Ignoram evenimentele de stergere (deleted) ca sa nu procesam fantome
        if event.event_type == 'deleted':
            return

        # Pentru 'moved', ne intereseaza destinatia. Pentru 'created'/'modified', sursa.
        path = event.dest_path if event.event_type == 'moved' else event.src_path
        
        logging.info(f"--> EVENT DETECTAT: {event.event_type} pe {path}")
        
        # Punem in coada
        self.processing_queue.put(path)

if __name__ == "__main__":
    ingestor = LogIngestor()
    ingestor.run()