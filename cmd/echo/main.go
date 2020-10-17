package main

import (
	"fmt"
	"log"
	"net/http"
)

const addr = ":8000"

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Println("Got request:", r.URL)
		msg := fmt.Sprintf("URL: %s\nHeaders:\n", r.URL)

		for k, v := range r.Header {
			msg += fmt.Sprintf("  - %s: %s\n", k, v)
		}

		w.Write([]byte(msg))
	})

	log.Printf("Listening on %s", addr)

	err := http.ListenAndServe(":8000", mux)

	if err != http.ErrServerClosed {
		log.Println("LISTEN ERROR:", err)
	}
}
