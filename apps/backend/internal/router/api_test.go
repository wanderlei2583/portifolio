package router

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"codeberg.org/Toriama/wrtoriama-backend/internal/config"
)

type apiResponse struct {
	Message string `json:"message"`
	Data    any    `json:"data"`
}

func TestAPIHealthEndpoint(t *testing.T) {
	r := Initialize(&config.Config{})

	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rr := httptest.NewRecorder()
	r.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected status %d, got %d", http.StatusOK, rr.Code)
	}

	var resp apiResponse
	if err := json.NewDecoder(rr.Body).Decode(&resp); err != nil {
		t.Fatalf("decode response: %v", err)
	}
	if resp.Message != "System is operational" {
		t.Fatalf("expected message %q, got %q", "System is operational", resp.Message)
	}
}

func TestAPIProjectsEndpoint(t *testing.T) {
	r := Initialize(&config.Config{})

	req := httptest.NewRequest(http.MethodGet, "/api/projects", nil)
	rr := httptest.NewRecorder()
	r.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected status %d, got %d", http.StatusOK, rr.Code)
	}

	var resp apiResponse
	if err := json.NewDecoder(rr.Body).Decode(&resp); err != nil {
		t.Fatalf("decode response: %v", err)
	}
	if resp.Message != "Success" {
		t.Fatalf("expected message %q, got %q", "Success", resp.Message)
	}

	items, ok := resp.Data.([]any)
	if !ok {
		t.Fatalf("expected data to be a list, got %T", resp.Data)
	}
	if len(items) == 0 {
		t.Fatalf("expected projects list to be non-empty")
	}
}
