package config

import (
	"os"
	"testing"
)

func TestLoadDefaults(t *testing.T) {
	t.Setenv("PORT", "")
	t.Setenv("ALLOWED_ORIGINS", "")
	t.Setenv("APP_ENV", "")

	cfg := Load()

	if cfg.Port != "8080" {
		t.Fatalf("expected default port 8080, got %q", cfg.Port)
	}
	if cfg.Env != "production" {
		t.Fatalf("expected default env production, got %q", cfg.Env)
	}
	if len(cfg.AllowedOrigins) != 0 {
		t.Fatalf("expected empty allowed origins, got %v", cfg.AllowedOrigins)
	}
}

func TestLoadCustomValues(t *testing.T) {
	t.Setenv("PORT", "9090")
	t.Setenv("ALLOWED_ORIGINS", "https://a.com, https://b.com")
	t.Setenv("APP_ENV", "staging")

	cfg := Load()

	if cfg.Port != "9090" {
		t.Fatalf("expected port 9090, got %q", cfg.Port)
	}
	if cfg.Env != "staging" {
		t.Fatalf("expected env staging, got %q", cfg.Env)
	}
	if len(cfg.AllowedOrigins) != 2 {
		t.Fatalf("expected 2 allowed origins, got %v", cfg.AllowedOrigins)
	}
	if cfg.AllowedOrigins[0] != "https://a.com" || cfg.AllowedOrigins[1] != "https://b.com" {
		t.Fatalf("unexpected allowed origins: %v", cfg.AllowedOrigins)
	}
}

func TestParseAllowedOriginsTrimsAndSkipsEmpty(t *testing.T) {
	got := parseAllowedOrigins("  https://a.com , , https://b.com  ,")
	if len(got) != 2 {
		t.Fatalf("expected 2 origins, got %v", got)
	}
	if got[0] != "https://a.com" || got[1] != "https://b.com" {
		t.Fatalf("unexpected origins: %v", got)
	}
}

func TestParseAllowedOriginsUsesEnvFallback(t *testing.T) {
	t.Setenv("PORT", "")
	t.Setenv("APP_ENV", "")
	t.Setenv("ALLOWED_ORIGINS", "https://wrtoriama.dev.br")

	cfg := Load()
	if len(cfg.AllowedOrigins) != 1 || cfg.AllowedOrigins[0] != "https://wrtoriama.dev.br" {
		t.Fatalf("unexpected allowed origins: %v", cfg.AllowedOrigins)
	}
}

func TestLoadDoesNotLeakEnv(t *testing.T) {
	t.Setenv("PORT", "")
	t.Setenv("ALLOWED_ORIGINS", "")
	t.Setenv("APP_ENV", "")

	cfg := Load()
	if os.Getenv("PORT") != "" || os.Getenv("ALLOWED_ORIGINS") != "" || os.Getenv("APP_ENV") != "" {
		t.Fatalf("expected env vars to stay empty")
	}
	if cfg == nil {
		t.Fatalf("expected config to be initialized")
	}
}
