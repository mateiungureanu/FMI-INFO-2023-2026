package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"math"
	"net"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"time"
)

var (
	addr        = flag.String("addr", "127.0.0.1:9000", "adresa:port a serverului")
	n           = flag.Int("n", 1000, "numarul total de mesaje de trimis")
	qps         = flag.Float64("qps", 0, "rata tinta mesaje/sec (0 = cât de repede se poate)")
	concurrency = flag.Int("c", 10, "numarul de conexiuni concurente (workers)")
	timeout     = flag.Duration("timeout", 5*time.Second, "timeout de conectare")
	readTimeout = flag.Duration("read-timeout", 0, "timeout de citire a raspunsului pe fiecare request (0 = fara)")
	payload     = flag.String("payload", "ping", "mesajul trimis per request (se adauga newline automat)")
	warmup      = flag.Int("warmup", 0, "numar mesaje de warmup (nu sunt contabilizate). 0 = fara")
)

type job struct {
	id int
}

type result struct {
	ok       bool
	latency  time.Duration
	errShort string
}

func main() {
	flag.Parse()
	if *n <= 0 {
		log.Fatalf("-n trebuie > 0")
	}
	if *concurrency <= 0 {
		log.Fatalf("-c trebuie > 0")
	}

	// initializam conexiunile (pool de workers)
	log.Printf("Conectare la %s cu c=%d ...", *addr, *concurrency)
	conns := make([]net.Conn, *concurrency)
	for i := 0; i < *concurrency; i++ {
		dialer := net.Dialer{Timeout: *timeout}
		c, err := dialer.Dial("tcp", *addr)
		if err != nil {
			log.Fatalf("nu ma pot conecta (worker %d): %v", i, err)
		}
		conns[i] = c
	}
	defer func() {
		for _, c := range conns {
			_ = c.Close()
		}
	}()

	// warmup (optional, necontabilizat)
	if *warmup > 0 {
		log.Printf("Warmup: %d mesaje...", *warmup)
		_ = runPhase(conns, *warmup, 0, *payload, *readTimeout, true)
	}

	// faza de benchmark
	log.Printf("Benchmark: N=%d, QPS=%.2f, c=%d", *n, *qps, *concurrency)
	stats := runPhase(conns, *n, *qps, *payload, *readTimeout, false)

	printReport(stats)
}

type statsSummary struct {
	total       int
	success     int64
	fail        int64
	start       time.Time
	end         time.Time
	latencies   []time.Duration
	errorsShort map[string]int
}

func runPhase(conns []net.Conn, total int, targetQPS float64, msg string, perReadTimeout time.Duration, silent bool) statsSummary {
	jobs := make(chan job, total)
	results := make(chan result, total)

	var started, finished int64

	// producator: pace cu QPS (sau fara limita)
	go func() {
		defer close(jobs)
		if targetQPS <= 0 {
			// fara limita
			for i := 0; i < total; i++ {
				jobs <- job{id: i}
			}
			return
		}
		// pace fix cu ticker
		interval := time.Duration(float64(time.Second) / targetQPS)
		t := time.NewTicker(interval)
		defer t.Stop()
		for i := 0; i < total; i++ {
			<-t.C
			jobs <- job{id: i}
		}
	}()

	var wg sync.WaitGroup
	wg.Add(len(conns))
	for wi := range conns {
		conn := conns[wi]
		go func(id int, c net.Conn) {
			defer wg.Done()
			reader := bufio.NewReader(c)
			writer := bufio.NewWriter(c)

			for range jobs { // <-- fix: nu folosim j
				atomic.AddInt64(&started, 1)

				if perReadTimeout > 0 {
					_ = c.SetReadDeadline(time.Now().Add(perReadTimeout))
				}

				t0 := time.Now()
				// scriem mesajul cu newline
				if _, err := writer.WriteString(msg + "\n"); err != nil {
					results <- result{ok: false, errShort: shortErr(err)}
					continue
				}
				if err := writer.Flush(); err != nil {
					results <- result{ok: false, errShort: shortErr(err)}
					continue
				}

				// citim raspuns o linie
				resp, err := reader.ReadString('\n')
				lat := time.Since(t0)

				if err != nil {
					results <- result{ok: false, errShort: classifyReadErr(err)}
					continue
				}
				// validare simpla (optional): raspunsul nu e gol
				if len(resp) == 0 {
					results <- result{ok: false, errShort: "empty-response"}
					continue
				}

				results <- result{ok: true, latency: lat}
				atomic.AddInt64(&finished, 1)
				_ = id // pastram id doar daca vrei logging; altfel poti elimina linia
			}
		}(wi, conn)
	}

	// colector
	s := statsSummary{
		total:       total,
		start:       time.Now(),
		errorsShort: map[string]int{},
	}
	go func() {
		wg.Wait()
		close(results)
	}()

	for r := range results {
		if r.ok {
			s.success++
			s.latencies = append(s.latencies, r.latency)
		} else {
			s.fail++
			s.errorsShort[r.errShort]++
		}
	}

	s.end = time.Now()
	if !silent {
		log.Printf("Trimise: %d | Reusite: %d | Esecuri: %d", started, s.success, s.fail)
	}
	return s
}

func printReport(s statsSummary) {
	elapsed := s.end.Sub(s.start)
	throughput := float64(s.success) / elapsed.Seconds()

	fmt.Println("=== Rezultate benchmark ===")
	fmt.Printf("Durata:      %v\n", elapsed)
	fmt.Printf("Total:       %d\n", s.total)
	fmt.Printf("Succes:      %d\n", s.success)
	fmt.Printf("Esecuri:     %d\n", s.fail)
	fmt.Printf("Throughput:  %.2f rsp/s\n", throughput)

	if len(s.errorsShort) > 0 {
		fmt.Println("Erori (top):")
		type kv struct {
			k string
			v int
		}
		var pairs []kv
		for k, v := range s.errorsShort {
			pairs = append(pairs, kv{k, v})
		}
		sort.Slice(pairs, func(i, j int) bool { return pairs[i].v > pairs[j].v })
		for i := 0; i < len(pairs) && i < 5; i++ {
			fmt.Printf("  %s: %d\n", pairs[i].k, pairs[i].v)
		}
	}

	if len(s.latencies) == 0 {
		fmt.Println("Nu sunt latente de raportat (toate au esuat?).")
		return
	}

	sort.Slice(s.latencies, func(i, j int) bool { return s.latencies[i] < s.latencies[j] })
	fmt.Println("Latente (ms):")
	fmt.Printf("  avg : %.2f\n", toMs(avg(s.latencies)))
	fmt.Printf("  p50 : %.2f\n", toMs(pct(s.latencies, 50)))
	fmt.Printf("  p95 : %.2f\n", toMs(pct(s.latencies, 95)))
	fmt.Printf("  p99 : %.2f\n", toMs(pct(s.latencies, 99)))
	fmt.Printf("  max : %.2f\n", toMs(s.latencies[len(s.latencies)-1]))
}

func toMs(d time.Duration) float64 { return float64(d) / float64(time.Millisecond) }

func avg(v []time.Duration) time.Duration {
	var sum int64
	for _, d := range v {
		sum += int64(d)
	}
	return time.Duration(sum / int64(len(v)))
}

func pct(sorted []time.Duration, p float64) time.Duration {
	if len(sorted) == 0 {
		return 0
	}
	if p <= 0 {
		return sorted[0]
	}
	if p >= 100 {
		return sorted[len(sorted)-1]
	}
	// nearest-rank
	rank := int(math.Ceil((p / 100.0) * float64(len(sorted))))
	idx := minInt(len(sorted)-1, maxInt(0, rank-1))
	return sorted[idx]
}

func minInt(a, b int) int {
	if a < b {
		return a
	}
	return b
}
func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func shortErr(err error) string {
	s := err.Error()
	if i := strings.IndexByte(s, ':'); i > 0 {
		return s[:i]
	}
	return s
}

func classifyReadErr(err error) string {
	// compacteaza putin mesajele comune
	msg := err.Error()
	switch {
	case strings.Contains(msg, "i/o timeout"):
		return "read-timeout"
	case strings.Contains(msg, "use of closed network connection"):
		return "closed-conn"
	default:
		return shortErr(err)
	}
}
