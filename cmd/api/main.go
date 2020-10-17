package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

const (
	addr = ":8000"
	pathKeyDogID = "dogID"
)

func main() {
	r := mux.NewRouter()

	r.HandleFunc(fmt.Sprintf("/dog/{%s}", pathKeyDogID), func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)

		log.Println("Got request for dog")

		w.Write([]byte(
			fmt.Sprintf("Dog: %q\n", vars[pathKeyDogID]),
		))
	})

	log.Println("Listening on", addr)
	err := http.ListenAndServe(addr, r)

	if err != http.ErrServerClosed {
		log.Println("LISTEN ERROR:", err)
	}
}
