require "rails_helper"

RSpec.describe "Auth", type: :request do
  describe "POST /auth/register" do
    let(:valid_params) do
      {
        user: {
          email: "user@example.com",
          password: "senha123",
          password_confirmation: "senha123"
        }
      }
    end

    context "com dados válidos" do
      it "cria usuário e retorna token" do
        post "http://localhost/auth/register", params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        json = response.parsed_body
        expect(json["token"]).to be_present
        expect(json["user"]["email"]).to eq("user@example.com")
        expect(json["user"]["id"]).to be_present
      end
    end

    context "com dados inválidos" do
      it "retorna erro quando email já existe" do
        User.create!(email: "user@example.com", password: "senha123")
        post "http://localhost/auth/register", params: valid_params, as: :json

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["errors"]).to be_present
      end

      it "retorna erro quando senha não confere" do
        post "http://localhost/auth/register", params: {
          user: {
            email: "user@example.com",
            password: "senha123",
            password_confirmation: "outra_senha"
          }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["errors"]).to be_present
      end

      it "retorna erro quando email é inválido" do
        post "http://localhost/auth/register", params: {
          user: {
            email: "email_invalido",
            password: "senha123",
            password_confirmation: "senha123"
          }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["errors"]).to be_present
      end
    end
  end

  describe "POST /auth/login" do
    let!(:user) { User.create!(email: "user@example.com", password: "senha123") }

    context "com credenciais válidas" do
      it "retorna token e dados do usuário" do
        post "http://localhost/auth/login", params: { email: "user@example.com", password: "senha123" }, as: :json

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json["token"]).to be_present
        expect(json["user"]["email"]).to eq("user@example.com")
        expect(json["user"]["id"]).to eq(user.id)
      end
    end

    context "com credenciais inválidas" do
      it "retorna 401 quando senha está errada" do
        post "http://localhost/auth/login", params: { email: "user@example.com", password: "senha_errada" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to eq("Invalid email or password")
      end

      it "retorna 401 quando email não existe" do
        post "http://localhost/auth/login", params: { email: "naoexiste@example.com", password: "senha123" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "GET /auth/me" do
    let!(:user) { User.create!(email: "user@example.com", password: "senha123") }

    context "com token válido" do
      it "retorna dados do usuário" do
        post "http://localhost/auth/login", params: { email: "user@example.com", password: "senha123" }, as: :json
        token = response.parsed_body["token"]

        get "http://localhost/auth/me", headers: { "Authorization" => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        json = response.parsed_body
        expect(json["user"]["email"]).to eq("user@example.com")
        expect(json["user"]["id"]).to eq(user.id)
      end
    end

    context "sem token" do
      it "retorna 401" do
        get "http://localhost/auth/me"

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to eq("Unauthorized")
      end
    end

    context "com token inválido" do
      it "retorna 401" do
        get "http://localhost/auth/me", headers: { "Authorization" => "Bearer token_invalido" }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to eq("Unauthorized")
      end
    end
  end
end

