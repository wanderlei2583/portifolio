package router

import (
	"codeberg.org/Toriama/wrtoriama-backend/internal/config"
	"codeberg.org/Toriama/wrtoriama-backend/internal/handlers"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

func Initialize(cfg *config.Config) *chi.Mux {
	r := chi.NewRouter()

	// Middlewares básicos de governança (Logs e Recuperação de Pânico)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	// Configuração do CORS
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"https://*", "http://*"}, // Refine isso em produção!
		AllowedMethods:   []string{"GET", "POST", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Rotas
	r.Get("/health", handlers.HealthCheck)
	r.Get("/api/projects", handlers.GetProjects)

	return r
}
