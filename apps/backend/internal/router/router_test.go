package router

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"codeberg.org/Toriama/wrtoriama-backend/internal/config"
)

func TestSecurityHeadersApplied(t *testing.T) {
	cfg := &config.Config{
		Port:           "8080",
		AllowedOrigins: []string{"https://example.com"},
		Env:            "test",
	}
	r := Initialize(cfg)

	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rr := httptest.NewRecorder()
	r.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected status %d, got %d", http.StatusOK, rr.Code)
	}

	headers := []string{
		"Content-Security-Policy",
		"Referrer-Policy",
		"X-Content-Type-Options",
		"X-Frame-Options",
		"Permissions-Policy",
		"Cross-Origin-Opener-Policy",
		"Cross-Origin-Resource-Policy",
	}
	for _, h := range headers {
		if rr.Header().Get(h) == "" {
			t.Fatalf("expected header %s to be set", h)
		}
	}
}

func TestCORSPreflightAllowedOrigin(t *testing.T) {
	cfg := &config.Config{
		AllowedOrigins: []string{"https://example.com"},
	}
	r := Initialize(cfg)

	req := httptest.NewRequest(http.MethodOptions, "/api/projects", nil)
	req.Header.Set("Origin", "https://example.com")
	req.Header.Set("Access-Control-Request-Method", "GET")

	rr := httptest.NewRecorder()
	r.ServeHTTP(rr, req)

	if got := rr.Header().Get("Access-Control-Allow-Origin"); got != "https://example.com" {
		t.Fatalf("expected Access-Control-Allow-Origin to be set, got %q", got)
	}
}

func TestCORSDisabledWhenNoOrigins(t *testing.T) {
	cfg := &config.Config{
		AllowedOrigins: []string{},
	}
	r := Initialize(cfg)

	req := httptest.NewRequest(http.MethodOptions, "/api/projects", nil)
	req.Header.Set("Origin", "https://example.com")
	req.Header.Set("Access-Control-Request-Method", "GET")

	rr := httptest.NewRecorder()
	r.ServeHTTP(rr, req)

	if got := rr.Header().Get("Access-Control-Allow-Origin"); got != "" {
		t.Fatalf("expected no CORS header, got %q", got)
	}
}
