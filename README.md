# Ruby API

API base em Ruby on Rails com Docker, PostgreSQL, Redis e autenticação JWT.

## Serviços

- **Rails** - API na porta 3000
- **PostgreSQL** - Banco de dados na porta 5432
- **Redis** - Cache na porta 6379

## Como subir

```bash
docker compose up
```

A API estará disponível em http://localhost:3000

## Como rodar os testes

```bash
docker compose run --rm web bundle exec rspec
```

Com nome dos testes:

```bash
docker compose run --rm web bundle exec rspec --format documentation
```

## Documentação da API (Swagger)

Com a API rodando, acesse http://localhost:3000/api-docs para ver a documentação interativa.

Para regenerar o Swagger após alterar os endpoints:

```bash
docker compose run --rm web bundle exec rake rswag:specs:swaggerize
```