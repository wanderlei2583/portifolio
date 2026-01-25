package config

import (
	"os"
	"strings"
)

type Config struct {
	Port           string
	AllowedOrigins []string
	Env            string
}

func Load() *Config {
	cfg := &Config{
		Port:           os.Getenv("PORT"),
		AllowedOrigins: parseAllowedOrigins(os.Getenv("ALLOWED_ORIGINS")),
		Env:            os.Getenv("APP_ENV"),
	}

	if cfg.Port == "" {
		cfg.Port = "8080"
	}

	if cfg.Env == "" {
		cfg.Env = "production"
	}

	return cfg
}

func parseAllowedOrigins(raw string) []string {
	if strings.TrimSpace(raw) == "" {
		return []string{}
	}

	parts := strings.Split(raw, ",")
	out := make([]string, 0, len(parts))
	for _, p := range parts {
		if v := strings.TrimSpace(p); v != "" {
			out = append(out, v)
		}
	}

	return out
}
