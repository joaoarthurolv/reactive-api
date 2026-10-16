---
inclusion: always
---

# Stack técnica

## Linguagem e build
- **Java 21** (compilado com `-parameters`).
- **Maven** via wrapper (`./mvnw` / `mvnw.cmd`). Sempre use o wrapper, não um
  Maven global.

## Frameworks e bibliotecas
- **Spring Boot 4.1.0** (parent).
- **Spring WebFlux** — camada web reativa (Netty, não Tomcat).
- **Spring Data R2DBC** — acesso a dados reativo e não bloqueante.
- **Flyway** — migrations de schema (roda sobre conexão JDBC blocante só na
  inicialização).
- **PostgreSQL** — driver R2DBC (`r2dbc-postgresql`) em runtime e driver JDBC
  (`postgresql`) usado apenas pelo Flyway.
- **Spring Boot Actuator** — métricas e health checks.

## Banco de dados
- PostgreSQL 15 via Docker Compose (`docker-compose.yml`).
- Exposto na porta host **5433** → container 5432.
- Database `codechella`, usuário/senha `postgres`/`postgres`.
- Runtime usa R2DBC: `r2dbc:postgresql://localhost:5433/codechella`.
- Flyway usa JDBC: `jdbc:postgresql://localhost:5433/codechella`.

## Comandos essenciais
```bash
# Subir o banco
docker compose up -d

# Rodar a aplicação
./mvnw spring-boot:run        # Linux/macOS
.\mvnw.cmd spring-boot:run    # Windows PowerShell

# Rodar os testes
./mvnw test

# Build completo
./mvnw clean verify
```

## Regras de ouro do reativo
- **Nunca** bloqueie uma thread no caminho reativo: nada de `.block()`,
  `.toFuture().get()`, JDBC blocante ou I/O síncrono dentro de um pipeline
  `Mono`/`Flux`.
- Retorne `Mono<T>` para 0..1 elemento e `Flux<T>` para 0..N.
- Faça side effects com `doOnNext`/`doOnError`/`doFinally`, não dentro de `map`.
- Propague o contexto reativo (`Context`) em vez de usar `ThreadLocal`.
- Prefira operadores declarativos a `subscribe()` manual dentro de handlers.
