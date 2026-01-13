package config

import (
	"os"
)

type Config struct {
	Port          string
	AllowedOrigin string
}

func Load() *Config {
	cfg := &Config{
		Port:          os.Getenv("PORT"),
		AllowedOrigin: os.Getenv("ALLOWED_ORIGIN"),
	}

	if cfg.Port == "" {
		cfg.Port = "8080"
	}

	if cfg.AllowedOrigin == "" {
		cfg.AllowedOrigin = "*"
	}

	return cfg
}
