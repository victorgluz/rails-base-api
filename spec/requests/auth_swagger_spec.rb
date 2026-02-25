require "swagger_helper"

RSpec.describe "Auth API", type: :request do
  path "/auth/register" do
    post "Registra novo usuário" do
      tags "Auth"
      consumes "application/json"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: "user@example.com" },
              password: { type: :string, example: "senha123" },
              password_confirmation: { type: :string, example: "senha123" }
            },
            required: %w[email password password_confirmation]
          }
        }
      }

      response "201", "usuário criado" do
        let(:user) { { user: { email: "user@example.com", password: "senha123", password_confirmation: "senha123" } } }
        run_test!
      end

      response "422", "dados inválidos" do
        let(:user) { { user: { email: "invalido", password: "123", password_confirmation: "456" } } }
        run_test!
      end
    end
  end

  path "/auth/login" do
    post "Autentica usuário" do
      tags "Auth"
      consumes "application/json"
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: "user@example.com" },
          password: { type: :string, example: "senha123" }
        },
        required: %w[email password]
      }

      response "200", "login realizado" do
        before { User.create!(email: "user@example.com", password: "senha123") }
        let(:credentials) { { email: "user@example.com", password: "senha123" } }
        run_test!
      end

      response "401", "credenciais inválidas" do
        let(:credentials) { { email: "user@example.com", password: "errada" } }
        run_test!
      end
    end
  end

  path "/auth/me" do
    get "Retorna dados do usuário autenticado" do
      tags "Auth"
      security [Bearer: {}]
      parameter name: "Authorization", in: :header, type: :string, description: "Bearer token"

      response "200", "dados do usuário" do
        before do
          User.create!(email: "user@example.com", password: "senha123")
          post "http://localhost/auth/login", params: { email: "user@example.com", password: "senha123" }, as: :json
          @token = response.parsed_body["token"]
        end
        let("Authorization") { "Bearer #{@token}" }
        run_test!
      end

      response "401", "não autenticado" do
        let("Authorization") { nil }
        run_test!
      end
    end
  end
end
