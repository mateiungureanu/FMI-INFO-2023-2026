package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
	"text/tabwriter"
	"time"
)

// Predefinim câteva layout‑uri uzuale (Go folosește referința 2006-01-02 15:04:05)
var layouts = map[string]string{
	"iso8601":      time.RFC3339,
	"iso8601_nano": time.RFC3339Nano,
	"rfc1123":      time.RFC1123,
	"rfc1123z":     time.RFC1123Z,
	"rfc822":       time.RFC822,
	"rfc822z":      time.RFC822Z,
	"stamp":        time.Stamp, // "Jan _2 15:04:05"
	"date":         "2006-01-02",
	"datetime":     "2006-01-02 15:04:05",
	"datetime_m":   "2006-01-02 15:04",
	"time":         "15:04:05",
}

// cand formatul nu este specificat, încercăm automat câteva layout-uri cunoscute + unix seconds
var autoTry = []string{
	time.RFC3339Nano,
	time.RFC3339,
	time.RFC1123Z,
	time.RFC1123,
	time.RFC822Z,
	time.RFC822,
	"2006-01-02 15:04:05",
	"2006-01-02 15:04",
	"2006-01-02",
	"15:04:05",
	"15:04",
}

func listFormats() {
	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)
	fmt.Fprintln(w, "Nume\tLayout")
	keys := make([]string, 0, len(layouts))
	for k := range layouts {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	for _, k := range keys {
		fmt.Fprintf(w, "%s\t%s\n", k, layouts[k])
	}
	w.Flush()
}

func loadLoc(name string) (*time.Location, error) {
	if name == "" || name == "local" {
		return time.Local, nil
	}
	loc, err := time.LoadLocation(name)
	if err != nil {
		return nil, fmt.Errorf("nu pot încărca zona %q: %w", name, err)
	}
	return loc, nil
}

func parseWithLayout(s, layout, zone string) (time.Time, error) {
	loc, err := loadLoc(zone)
	if err != nil {
		return time.Time{}, err
	}
	// Dacă layout-ul produce timp fără informații de fus, îl interpretăm în zona selectată
	// Apoi îl convertim intern în UTC pentru calcule coerente
	t, err := time.ParseInLocation(layout, s, loc)
	if err != nil {
		return time.Time{}, err
	}
	return t, nil
}

// parseAuto: detectează automat layout-ul sau unix seconds.
func parseAuto(s, zone string) (time.Time, string, error) {
	ss := strings.TrimSpace(s)
	// suport unix seconds (ex: @1698650000 sau 1698650000)
	if strings.HasPrefix(ss, "@") {
		ss = ss[1:]
	}
	if n, err := strconv.ParseInt(ss, 10, 64); err == nil {
		return time.Unix(n, 0), "unix", nil
	}
	var lastErr error
	for _, ly := range autoTry {
		if t, err := parseWithLayout(ss, ly, zone); err == nil {
			return t, ly, nil
		} else {
			lastErr = err
		}
	}
	return time.Time{}, "", fmt.Errorf("nu am putut detecta formatul pentru %q: %v", s, lastErr)
}

func mustFormat(t time.Time, layout string, zone string) (string, error) {
	loc, err := loadLoc(zone)
	if err != nil {
		return "", err
	}
	return t.In(loc).Format(layout), nil
}

// humanizeDiff produce o descriere prietenoasă a unei durate (aprox.)
func humanizeDiff(d time.Duration) string {
	abs := d
	if abs < 0 {
		abs = -abs
	}
	days := int(abs.Hours()) / 24
	hours := int(abs.Hours()) % 24
	mins := int(abs.Minutes()) % 60
	secs := int(abs.Seconds()) % 60
	parts := []string{}
	if days != 0 {
		parts = append(parts, fmt.Sprintf("%dd", days))
	}
	if hours != 0 {
		parts = append(parts, fmt.Sprintf("%dh", hours))
	}
	if mins != 0 {
		parts = append(parts, fmt.Sprintf("%dm", mins))
	}
	if secs != 0 || len(parts) == 0 {
		parts = append(parts, fmt.Sprintf("%ds", secs))
	}
	if d < 0 {
		return "-" + strings.Join(parts, " ")
	}
	return strings.Join(parts, " ")
}

// ===== Subcomenzi =====

func cmdNow(args []string) {
	fs := flag.NewFlagSet("now", flag.ExitOnError)
	z := fs.String("z", "local", "zona (ex: Europe/Bucharest, UTC)")
	f := fs.String("f", "iso8601", "format (nume predefinit sau layout Go)")
	fs.Parse(args)
	loc, err := loadLoc(*z)
	if err != nil {
		fatal(err)
	}
	now := time.Now().In(loc)
	layout := layouts[*f]
	if layout == "" {
		layout = *f
	}
	out := now.Format(layout)
	fmt.Println(out)
}

func cmdFormat(args []string) {
	fs := flag.NewFlagSet("format", flag.ExitOnError)
	in := fs.String("in", "", "timpul de formatat (ex: 2025-10-30 10:00:00)")
	from := fs.String("from", "", "layout de intrare sau nume predefinit; dacă lipseste -> auto")
	to := fs.String("to", "iso8601", "layout de ieșire sau nume predefinit")
	inz := fs.String("inz", "local", "zona pentru interpretarea intrării dacă nu conține fus")
	outz := fs.String("outz", "local", "zona de ieșire")
	fs.Parse(args)
	if *in == "" {
		fatal(errors.New("folosire: format -in <valoare> [-from <layout|nume>] [-to <layout|nume>]"))
	}
	var t time.Time
	var err error
	if *from == "" {
		t, _, err = parseAuto(*in, *inz)
	} else {
		fl := layouts[*from]
		if fl == "" {
			fl = *from
		}
		t, err = parseWithLayout(*in, fl, *inz)
	}
	if err != nil {
		fatal(err)
	}
	toL := layouts[*to]
	if toL == "" {
		toL = *to
	}
	res, err := mustFormat(t, toL, *outz)
	if err != nil {
		fatal(err)
	}
	fmt.Println(res)
}

func cmdParse(args []string) {
	fs := flag.NewFlagSet("parse", flag.ExitOnError)
	in := fs.String("in", "", "valoare de parsat (auto-detect)")
	inz := fs.String("inz", "local", "zona pentru interpretare")
	fs.Parse(args)
	if *in == "" {
		fatal(errors.New("folosire: parse -in <valoare>"))
	}
	t, used, err := parseAuto(*in, *inz)
	if err != nil {
		fatal(err)
	}
	fmt.Println("Format detectat:", used)
	fmt.Println("UTC:", t.UTC().Format(time.RFC3339Nano))
	fmt.Println("Local:", t.Local().Format(time.RFC3339Nano))
}

func cmdDiff(args []string) {
	fs := flag.NewFlagSet("diff", flag.ExitOnError)
	a := fs.String("a", "", "timp A")
	b := fs.String("b", "", "timp B")
	from := fs.String("from", "", "layout pentru A/B sau auto")
	z := fs.String("z", "local", "zona de interpretare pentru intrări fără fus")
	unit := fs.String("u", "auto", "unitate: auto|days|hours|minutes|seconds")
	fs.Parse(args)
	if *a == "" || *b == "" {
		fatal(errors.New("folosire: diff -a <timp> -b <timp> [-from <layout|nume>]"))
	}
	var t1, t2 time.Time
	var err error
	if *from == "" {
		t1, _, err = parseAuto(*a, *z)
		if err != nil {
			fatal(err)
		}
		t2, _, err = parseAuto(*b, *z)
		if err != nil {
			fatal(err)
		}
	} else {
		fl := layouts[*from]
		if fl == "" {
			fl = *from
		}
		t1, err = parseWithLayout(*a, fl, *z)
		if err != nil {
			fatal(err)
		}
		t2, err = parseWithLayout(*b, fl, *z)
		if err != nil {
			fatal(err)
		}
	}
	diff := t2.Sub(t1)
	switch *unit {
	case "days":
		fmt.Printf("%.3f\n", diff.Hours()/24)
	case "hours":
		fmt.Printf("%.3f\n", diff.Hours())
	case "minutes":
		fmt.Printf("%.3f\n", diff.Minutes())
	case "seconds":
		fmt.Printf("%.3f\n", diff.Seconds())
	default:
		fmt.Println(humanizeDiff(diff))
	}
}

func cmdAdd(args []string) {
	fs := flag.NewFlagSet("add", flag.ExitOnError)
	in := fs.String("in", "", "timp de bază")
	from := fs.String("from", "", "layout sau auto")
	dur := fs.String("d", "", "durată Go (ex: 90m, 2h45m, -36h)")
	inz := fs.String("inz", "local", "zona de interpretare")
	to := fs.String("to", "iso8601", "layout rezultatul")
	outz := fs.String("outz", "local", "zona de ieșire")
	fs.Parse(args)
	if *in == "" || *dur == "" {
		fatal(errors.New("folosire: add -in <timp> -d <durată>"))
	}
	var t time.Time
	var err error
	if *from == "" {
		t, _, err = parseAuto(*in, *inz)
	} else {
		fl := layouts[*from]
		if fl == "" {
			fl = *from
		}
		t, err = parseWithLayout(*in, fl, *inz)
	}
	if err != nil {
		fatal(err)
	}
	D, err := time.ParseDuration(*dur)
	if err != nil {
		fatal(fmt.Errorf("durată invalidă: %w", err))
	}
	resT := t.Add(D)
	toL := layouts[*to]
	if toL == "" {
		toL = *to
	}
	out, err := mustFormat(resT, toL, *outz)
	if err != nil {
		fatal(err)
	}
	fmt.Println(out)
}

func cmdList(args []string) {
	_ = args
	listFormats()
}

// ===== util =====

func usage() {
	fmt.Println(`dtcli – gestionare și afișare date/timp
Subcomenzi:
  now      [-z <zona>] [-f <format>]
  parse    -in <valoare> [-inz <zona>]
  format   -in <valoare> [-from <layout|nume>] [-to <layout|nume>] [-inz <zona>] [-outz <zona>]
  diff     -a <timp> -b <timp> [-from <layout|nume>] [-z <zona>] [-u auto|days|hours|minutes|seconds]
  add      -in <timp> -d <durată> [-from <layout|nume>] [-inz <zona>] [-to <layout|nume>] [-outz <zona>]
  list     (listează formatele predefinite)

Exemple:
  dtcli now -z UTC -f iso8601
  dtcli parse -in "2025-10-30 10:15" -inz Europe/Bucharest
  dtcli format -in 1698650000 -to rfc1123z       # unix seconds
  dtcli diff -a "2025-10-30 08:00" -b "2025-10-31 09:30" -u hours -z Europe/Bucharest
  dtcli add -in "2025-10-30T10:00:00+02:00" -d 36h -to datetime
  dtcli list
`)
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, "Eroare:", err)
	os.Exit(2)
}

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(1)
	}
	sub := os.Args[1]
	switch sub {
	case "now":
		cmdNow(os.Args[2:])
	case "parse":
		cmdParse(os.Args[2:])
	case "format":
		cmdFormat(os.Args[2:])
	case "diff":
		cmdDiff(os.Args[2:])
	case "add":
		cmdAdd(os.Args[2:])
	case "list":
		cmdList(os.Args[2:])
	default:
		usage()
		os.Exit(1)
	}
}
