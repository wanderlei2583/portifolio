package main

import (
	"context"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"codeberg.org/Toriama/wrtoriama-backend/internal/config"
	"codeberg.org/Toriama/wrtoriama-backend/internal/router"
)

func main() {
	// 1. Logger estruturado (Padrão Go 1.21+)
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	// 2. Carregar Configurações
	cfg := config.Load()

	// 3. Inicializar Roteador
	r := router.Initialize(cfg)

	// 4. Configurar Servidor
	srv := &http.Server{
		Addr:         ":" + cfg.Port,
		Handler:      r,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// 5. Iniciar Servidor em uma Goroutine
	go func() {
		slog.Info("Server starting", "port", cfg.Port, "env", "production")
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			slog.Error("Could not listen on", "addr", cfg.Port, "error", err)
			os.Exit(1)
		}
	}()

	// 6. Graceful Shutdown (Governança)
	// Aguarda sinal de interrupção (Ctrl+C ou SIGTERM do Docker/Kubernetes)
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)

	// Bloqueia até receber o sinal
	<-c
	slog.Info("Shutting down server...")

	// Cria contexto com timeout de 10s para finalizar requisições pendentes
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		slog.Error("Server forced to shutdown", "error", err)
	}

	slog.Info("Server exited properly")
}
