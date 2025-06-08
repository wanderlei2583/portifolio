# Portfólio Pessoal | [Wanderlei R Pereira]

## 📖 Sobre o Projeto
Este é o repositório do meu portfólio pessoal, desenvolvido para apresentar meus projetos, habilidades e minha jornada como desenvolvedor. O projeto segue uma estética minimalista, com foco total no conteúdo e na experiência do usuário.
O backend é construído em Go (Golang) para garantir alta performance e escalabilidade, enquanto o frontend é desenvolvido com React e Vite para uma interface moderna, rápida e reativa.

Visite a versão online: [Em Construção...](./assets/under-construction-2891888_960_720.jpg)

## ✨ Funcionalidades Principais
* Design Minimalista:  Interface limpa e focada, com amplo uso de espaço em branco para uma navegação intuitiva.
* Backend Performático: API RESTful desenvolvida em Go para servir os dados do portfólio de forma rápida e eficiente.
* Frontend Reativo: Interface construída com React, garantindo uma experiência de usuário fluida e dinâmica sem recarregamento de páginas.
* Formulário de Contato Funcional: Um endpoint no backend processa as mensagens enviadas pelo formulário de contato, notificando-me por email.
* Projetos Dinâmicos: Os projetos são carregados a partir da API, facilitando a adição de novos trabalhos sem a necessidade de um novo deploy do frontend.

## 🚀 Tecnologias Utilizadas
Este projeto foi construído utilizando as seguintes tecnologias:
| Tecnologia | Descrição | 
| Go (Golang) | Linguagem utilizada para o desenvolvimento do backend e da API.|
| Gin | Framework web para Go, usado para criar o servidor e as rotas da API.|
| React | Biblioteca JavaScript para a construção da interface de usuário.|
| Vite | Ferramenta de build para um desenvolvimento frontend extremamente rápido.|
| TypeScript |  Superset do JavaScript que adiciona tipagem estática ao código.|
| Axios | Cliente HTTP para realizar as chamadas à API do backend.|
| Tailwind | CSSFramework CSS utility-first para estilização rápida e consistente.| 
| Docker | Utilizado para criar um ambiente de desenvolvimento e produção conteinerizado.|

## 🛠️ Como Executar o Projeto Localmente
Siga os passos abaixo para rodar o projeto em sua máquina.
Pré-requisitos
* Go (versão 1.22 ou superior)
* Node.js (versão 20 ou superior)
* Git

### Clonando o Repositório
```sh 
git clone https://github.com/wanderlei2583/portifolio.git
cd portifolio

```
### Backend (Go)
~~~sh 
# Navegue até a pasta do backend (ex: /server)
cd server

# Instale as dependências
go mod tidy

# Crie um arquivo .env com base no .env.example (se houver)
# Ex: cp .env.example .env

# Execute o servidor de desenvolvimento
go run main.go
~~~

O servidor backend estará rodando em `http://localhost:8080`.

### Frontend (React)
~~~sh 
# Em um novo terminal, navegue até a pasta do frontend (ex: /client)
cd client

# Instale as dependências
npm install

# Execute o servidor de desenvolvimento
npm run dev
~~~

O frontend estará acessível em `http://localhost:5173`.

## 📝 Endpoints da API
A API do backend possui os seguintes endpoints:
* `GET /api/projects`: Retorna uma lista com todos os projetos.
* `POST /api/contact`: Recebe os dados do formulário de contato.
    * Body (JSON):
    ~~~json 
    {
      "name": "string",
      "email": "string",
      "message": "string"
    }
    ~~~

## 📞 Contato
* Wanderlei 
* Email: wanderlei@tutamail.com
