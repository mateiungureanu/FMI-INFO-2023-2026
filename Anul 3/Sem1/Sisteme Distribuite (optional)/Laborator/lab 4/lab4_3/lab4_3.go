package main

// Aplicație CLI pentru gestionarea resurselor și parametrilor unui URL.
// Demonstrează lucrul cu pachetul "net/url" din Go și manipularea path-ului, query-ului și fragmentului.

import (
	"flag"    // pentru parsarea argumentelor din linia de comandă
	"fmt"     // pentru afișare
	"net/url" // pentru lucru cu structura URL
	"os"      // pentru ieșire / argumente
	"sort"    // pentru sortare
	"strings" // pentru operații pe stringuri
)

// Structură care înfășoară *url.URL și oferă metode ușor de folosit.
type URLManager struct {
	u *url.URL
}

// Parsează URL-ul sau iese cu eroare dacă nu e valid.
func mustParse(raw string) *url.URL {
	u, err := url.Parse(raw)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Eroare: URL invalid: %v\n", err)
		os.Exit(2)
	}
	return u
}

// Creează un manager nou pe baza unui URL string.
func NewURLManager(raw string) *URLManager {
	return &URLManager{u: mustParse(raw)}
}

// Returnează reprezentarea completă ca string.
func (m *URLManager) String() string {
	return m.u.String()
}

// ======== FUNCȚII PENTRU QUERY ========

// Obține valorile unei chei de query.
func (m *URLManager) GetParam(key string) []string {
	return m.u.Query()[key]
}

// Adaugă o valoare la o cheie existentă sau nouă.
func (m *URLManager) AddParam(key, value string) {
	q := m.u.Query()
	q.Add(key, value)
	m.u.RawQuery = q.Encode()
}

// Setează complet valorile pentru o cheie (șterge ce era înainte).
func (m *URLManager) SetParam(key string, values ...string) {
	q := m.u.Query()
	q.Del(key)
	for _, v := range values {
		q.Add(key, v)
	}
	m.u.RawQuery = q.Encode()
}

// Șterge o cheie complet.
func (m *URLManager) DelParam(key string) {
	q := m.u.Query()
	q.Del(key)
	m.u.RawQuery = q.Encode()
}

// Golește complet query-ul.
func (m *URLManager) ClearParams() {
	m.u.RawQuery = ""
}

// Sortează cheile și valorile pentru o ordine deterministă.
func (m *URLManager) NormalizeParams() {
	q := m.u.Query()
	for k := range q {
		vals := q[k]
		sort.Strings(vals)
		q[k] = vals
	}
	m.u.RawQuery = q.Encode()
}

// ======== FUNCȚII PENTRU PATH ========

// Adaugă segmente la path (ex: api, v1, users → /api/v1/users)
func (m *URLManager) AddPathSegments(segments ...string) {
	clean := func(s string) string { return strings.Trim(s, "/") }
	parts := []string{}
	if m.u.Path != "" && m.u.Path != "/" {
		parts = append(parts, clean(m.u.Path))
	}
	for _, s := range segments {
		if s = clean(s); s != "" {
			parts = append(parts, s)
		}
	}
	m.u.Path = "/" + strings.Join(parts, "/")
}

// Înlocuiește complet path-ul.
func (m *URLManager) ReplacePath(newPath string) {
	m.u.Path = "/" + strings.Trim(newPath, "/")
}

// ======== FUNCȚII PENTRU FRAGMENT ========

// Setează fragmentul (#...).
func (m *URLManager) SetFragment(frag string) {
	m.u.Fragment = frag
}

// ======== REZOLVARE URL RELATIV ========

// Combină un URL de bază cu unul relativ, conform RFC 3986.
func Resolve(base, ref string) (string, error) {
	b, err := url.Parse(base)
	if err != nil {
		return "", fmt.Errorf("base invalid: %w", err)
	}
	r, err := url.Parse(ref)
	if err != nil {
		return "", fmt.Errorf("ref invalid: %w", err)
	}
	return b.ResolveReference(r).String(), nil
}

// ======== CLI PRINCIPAL ========

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(1)
	}

	cmd := os.Args[1]

	switch cmd {
	case "add":
		fs := flag.NewFlagSet("add", flag.ExitOnError)
		u := fs.String("u", "", "URL de intrare")
		k := fs.String("k", "", "cheie")
		v := fs.String("v", "", "valoare")
		fs.Parse(os.Args[2:])
		m := NewURLManager(*u)
		m.AddParam(*k, *v)
		fmt.Println(m.String())

	case "set":
		fs := flag.NewFlagSet("set", flag.ExitOnError)
		u := fs.String("u", "", "URL")
		k := fs.String("k", "", "cheie")
		v := fs.String("v", "", "valori separate prin virgule")
		fs.Parse(os.Args[2:])
		m := NewURLManager(*u)
		m.SetParam(*k, strings.Split(*v, ",")...)
		fmt.Println(m.String())

	case "del":
		fs := flag.NewFlagSet("del", flag.ExitOnError)
		u := fs.String("u", "", "URL")
		k := fs.String("k", "", "cheie")
		fs.Parse(os.Args[2:])
		m := NewURLManager(*u)
		m.DelParam(*k)
		fmt.Println(m.String())

	case "addpath":
		fs := flag.NewFlagSet("addpath", flag.ExitOnError)
		u := fs.String("u", "", "URL")
		p := fs.String("p", "", "segmente de path (ex: api/v1)")
		fs.Parse(os.Args[2:])
		m := NewURLManager(*u)
		m.AddPathSegments(strings.Split(*p, "/")...)
		fmt.Println(m.String())

	case "frag":
		fs := flag.NewFlagSet("frag", flag.ExitOnError)
		u := fs.String("u", "", "URL")
		f := fs.String("f", "", "fragment")
		fs.Parse(os.Args[2:])
		m := NewURLManager(*u)
		m.SetFragment(*f)
		fmt.Println(m.String())

	case "resolve":
		fs := flag.NewFlagSet("resolve", flag.ExitOnError)
		b := fs.String("base", "", "URL bază")
		r := fs.String("ref", "", "URL relativ")
		fs.Parse(os.Args[2:])
		res, _ := Resolve(*b, *r)
		fmt.Println(res)

	default:
		usage()
	}
}

// Afișează ghidul de folosire.
func usage() {
	fmt.Print(`Comenzi disponibile:
  add      -u <url> -k <cheie> -v <valoare>
  set      -u <url> -k <cheie> -v "v1,v2"
  del      -u <url> -k <cheie>
  addpath  -u <url> -p "api/v1/users"
  frag     -u <url> -f "sectiune"
  resolve  -base <url> -ref <relativ>
Exemplu:
  go run . add -u "https://ex.com?x=1" -k "lang" -v "ro"
`)
}
