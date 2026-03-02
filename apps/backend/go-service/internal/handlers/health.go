package handlers

import (
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"net/http"
	"time"
)

func HealthHandler(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, map[string]any{
		"status": "ok",
		"at":     time.Now().UTC().Format(time.RFC3339Nano),
	})
}

// ReadyHandler is a hook for dependency checks.
// MVP: always ready. Growth: check DB/Redis connections here.
type ReadyConfig struct {
	// add dependency handles later (db, redis, etc.)
}

func ReadyHandler(_ any) http.HandlerFunc {
	return func(w http.ResponseWriter, _ *http.Request) {
		writeJSON(w, http.StatusOK, map[string]any{
			"ready": true,
			"at":    time.Now().UTC().Format(time.RFC3339Nano),
		})
	}
}

func GetUsers(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		w.Header().Set("Allow", http.MethodGet)
		writeJSON(w, http.StatusMethodNotAllowed, map[string]any{
			"error": map[string]any{
				"code":       "method_not_allowed",
				"message":    "only GET is allowed",
				"request_id": r.Header.Get("X-Request-Id"),
			},
		})
		return
	}

	users := []string{"user1", "user2", "user3"}
	writeJSON(w, http.StatusOK, users)
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

func NewRequestID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	return hex.EncodeToString(b[:])
}