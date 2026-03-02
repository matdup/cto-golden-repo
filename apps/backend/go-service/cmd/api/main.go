package main

import (
	"context"
	"errors"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"backend-go-service/internal/handlers"
)

func main() {
	cfg := mustLoadConfig()

	mux := http.NewServeMux()
	mux.HandleFunc("/health", handlers.HealthHandler)
	mux.HandleFunc("/ready", handlers.ReadyHandler(cfg)) // readiness can include deps later
	mux.HandleFunc("/api/users", handlers.GetUsers)

	srv := &http.Server{
		Addr:              ":" + strconv.Itoa(cfg.Port),
		Handler:           withMiddleware(mux),
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       15 * time.Second,
		WriteTimeout:      15 * time.Second,
		IdleTimeout:       60 * time.Second,
		BaseContext: func(_ net.Listener) context.Context {
			return context.Background()
		},
	}

	log.Printf("🚀 go-service listening on %s (env=%s)", srv.Addr, cfg.Env)

	// Graceful shutdown
	errCh := make(chan error, 1)
	go func() {
		if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			errCh <- err
		}
		close(errCh)
	}()

	stop := make(chan os.Signal, 2)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM)

	select {
	case sig := <-stop:
		log.Printf("🛑 received signal: %s", sig)
	case err := <-errCh:
		log.Printf("❌ server error: %v", err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		log.Printf("❌ graceful shutdown failed: %v", err)
		_ = srv.Close()
	} else {
		log.Printf("✅ shutdown complete")
	}
}

type config struct {
	Port int
	Env  string
}

func mustLoadConfig() config {
	port := envInt("PORT", 8080)
	env := envStr("APP_ENV", "local")
	return config{
		Port: port,
		Env:  env,
	}
}

func envStr(key, def string) string {
	v := os.Getenv(key)
	if v == "" {
		return def
	}
	return v
}

func envInt(key string, def int) int {
	v := os.Getenv(key)
	if v == "" {
		return def
	}
	n, err := strconv.Atoi(v)
	if err != nil {
		log.Fatalf("invalid %s=%q (expected int)", key, v)
	}
	return n
}

// Minimal middleware: request id + logging + secure headers.
func withMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		reqID := r.Header.Get("X-Request-Id")
		if reqID == "" {
			reqID = handlers.NewRequestID()
		}
		w.Header().Set("X-Request-Id", reqID)

		// Security headers baseline (edge should also enforce these)
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.Header().Set("X-Frame-Options", "DENY")
		w.Header().Set("Referrer-Policy", "no-referrer")

		next.ServeHTTP(w, r)

		log.Printf("req_id=%s method=%s path=%s remote=%s dur_ms=%d",
			reqID, r.Method, r.URL.Path, r.RemoteAddr, time.Since(start).Milliseconds(),
		)
	})
}