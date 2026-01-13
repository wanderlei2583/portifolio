package handlers

import (
	"encoding/json"
	"net/http"
)

type Response struct {
	Message string `json:"message"`
	Data    any    `json:"data,omitempty"`
}

func HealthCheck(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(Response{Message: "System is operational"})
}

func GetProjects(w http.ResponseWriter, r *http.Request) {
	projects := []map[string]string{
		{
			"title":       "Portfolio v1",
			"description": "Meu site pessoal com Go e React",
			"stack":       "Go, React, Docker",
		},
		{
			"title":       "CLI Tool",
			"description": "Ferramenta de automação em terminal",
			"stack":       "Bash, Python",
		},
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Response{
		Message: "Success",
		Data:    projects,
	})
}
