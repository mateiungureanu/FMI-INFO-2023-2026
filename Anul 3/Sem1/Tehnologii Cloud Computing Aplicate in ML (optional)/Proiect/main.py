import os
import uuid
import warnings
import google.generativeai as genai
from azure.cosmos import CosmosClient, PartitionKey
from dotenv import load_dotenv

warnings.filterwarnings("ignore")
os.environ["GRPC_VERBOSITY"] = "ERROR"
load_dotenv()

COSMOS_ENDPOINT = os.getenv("COSMOS_ENDPOINT")
COSMOS_KEY = os.getenv("COSMOS_KEY")
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")

if not all([COSMOS_ENDPOINT, COSMOS_KEY, GOOGLE_API_KEY]):
    print("EROARE: Lipsesc chei din .env!")
    exit()

AGENTS = {
    "1": {
        "name": "Technical Lead (Planner)",
        "role_desc": """Esti un Technical Lead pragmatic si extrem de capabil. 
        OBIECTIVUL TAU: Sa intelegi problema utilizatorului si sa creezi un 'Implementation Plan' detaliat.
        
        REGULI DE COMPORTAMENT:
        1. Nu propune microservicii sau cloud complex daca nu e strict necesar. Aplica principiul KISS (Keep It Simple, Stupid).
        2. Daca utilizatorul cere un script, gandeste-te la biblioteci, structura fisierelor, gestionarea erorilor.
        3. Daca nu ai informatii suficiente, intreaba utilizatorul pana clarifici.
        4. Cand ai inteles totul, genereaza un raspuns structurat ca un fisier Markdown (SPEC.md) care sa contina:
           - Scopul
           - Tehnologiile alese
           - Pasi de implementare pas-cu-pas.
        
        Esti creierul operatiunii. Nu scrii cod final, ci definesti CE trebuie scris."""
    },
    "2": {
        "name": "Senior Developer (Executant)",
        "role_desc": """Esti un Expert Software Engineer obsedat de calitate si corectitudine.
        OBIECTIVUL TAU: Sa implementezi STRICT planul stabilit de Technical Lead.
        
        REGULI DE CODING:
        1. Scrii cod conform principiilor SOLID, DRY (Don't Repeat Yourself) si Clean Code.
        2. Gestionezi erorile (try/except) si folosesti type hinting.
        3. Nu inventezi arhitectura noua. Urmezi planul din istoric.
        4. Daca planul e vag, iei cea mai buna decizie tehnica standard, dar comentezi in cod de ce.
        
        Esti mainile care construiesc. Scrii cod complet, functional, gata de rulare."""
    }
}

try:
    client = CosmosClient(COSMOS_ENDPOINT, COSMOS_KEY)
    
    database = client.create_database_if_not_exists(
        id="MemorieBotDB", 
        offer_throughput=400 
    )
    
    container = database.create_container_if_not_exists(
        id="ProiectAgenticIDE", 
        partition_key=PartitionKey(path="/sessionId")
    )
except Exception as e:
    print(f"Eroare Azure: {e}")
    exit()

genai.configure(api_key=GOOGLE_API_KEY)

def get_cag_context(session_id, limit=20):
    """
    Descarcă memoria persistentă (Shared State).
    Limitam e mai mare (20) pentru ca un Plan tehnic poate fi lung.
    """
    try:
        query = "SELECT * FROM c WHERE c.sessionId = @sessionId ORDER BY c._ts ASC"
        items = list(container.query_items(
            query=query,
            parameters=[{"name": "@sessionId", "value": session_id}],
            enable_cross_partition_query=True
        ))
        
        recent_items = items[-limit:] if limit else items

        history_for_gemini = []
        for item in recent_items:
            role = "user" if item['role'] == "user" else "model"
            history_for_gemini.append({"role": role, "parts": [item['content']]})
        
        return history_for_gemini
    except Exception as e:
        return []

def save_memory_trace(session_id, role, text, agent_name):
    """
    Salvează 'Knowledge' in Cosmos DB.
    """
    try:
        db_role = "assistant" if role == "model" else role
        new_item = {
            "id": str(uuid.uuid4()),
            "sessionId": session_id,
            "role": db_role,
            "content": text,
            "agentName": agent_name,
            "timestamp": str(uuid.uuid1().time)
        }
        container.create_item(body=new_item)
    except Exception as e:
        print(f"Eroare salvare DB: {e}")

def wipe_memory(session_id):
    """Resetare context."""
    try:
        query = "SELECT * FROM c WHERE c.sessionId = @sessionId"
        items = list(container.query_items(
            query=query,
            parameters=[{"name": "@sessionId", "value": session_id}],
            enable_cross_partition_query=True
        ))
        for item in items:
            container.delete_item(item, partition_key=session_id)
        print(f"--> [SYSTEM] Memoria pentru '{session_id}' a fost stearsa.")
    except Exception as e:
        print(f"Eroare stergere: {e}")

def main():
    print("\n--- AGENTIC IDE SIMULATOR (Planning -> Coding) ---")
    session_id = input("Nume Proiect (ex: scraper_bvb): ").strip()
    if not session_id: session_id = "demo_project"

    current_agent_key = "1" 
    
    print(f"\nProiectul '{session_id}' initializat.")
    print("Scrie '/switch' cand Planul e gata si vrei sa treci la Codare.")
    print("Scrie '/clean' daca vrei sa o iei de la zero.\n")

    while True:
        agent = AGENTS[current_agent_key]
        print(f"\n🔵 [MOD ACTIV: {agent['name']}]")
        
        model = genai.GenerativeModel(
            'gemini-3-flash-preview', 
            system_instruction=agent['role_desc']
        )
        
        history = get_cag_context(session_id, limit=20)
        chat = model.start_chat(history=history)

        while True:
            try:
                user_text = input(f"Tu (catre {agent['name'].split()[0]}): ")
                
                if user_text.lower() in ["exit", "quit"]:
                    return 

                if user_text.lower() == "/clean":
                    wipe_memory(session_id)
                    history = []
                    chat = model.start_chat(history=[])
                    print("--> Context resetat.")
                    continue

                if user_text.lower() == "/switch":
                    new_key = "2" if current_agent_key == "1" else "1"
                    current_agent_key = new_key
                    print(f"--> 🔄 Schimbare context catre: {AGENTS[new_key]['name']}...")
                    break 
                
                save_memory_trace(session_id, "user", user_text, "user")

                response = chat.send_message(user_text)
                ai_text = response.text
                
                print(f"\n{agent['name']}:\n{ai_text}\n")
                save_memory_trace(session_id, "model", ai_text, agent['name'])

            except Exception as e:
                print(f"Eroare: {e}")
                break

if __name__ == "__main__":
    main()