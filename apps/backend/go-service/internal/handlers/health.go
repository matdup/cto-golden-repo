package handlers

import (
	"net/http"
	"encoding/json"
)

func GetUsers(w http.ResponseWriter, r *http.Request) {
	users := []string{"user1", "user2", "user3"}
	json.NewEncoder(w).Encode(users)
}

func HealthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status":"ok"}`))
}
