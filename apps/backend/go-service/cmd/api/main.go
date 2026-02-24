package main

import (
	"log"
	"net/http"
	"backend-template/internal/handlers"  // handlers imports
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/health", handlers.HealthHandler)  // Use HealthHandler
	mux.HandleFunc("/api/users", handlers.GetUsers)    // Use GetUsers
	
	log.Println("🚀 Server starting on :8080")
	log.Fatal(http.ListenAndServe(":8080", mux))
}