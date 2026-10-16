---
inclusion: always
---

# Estrutura do projeto

## Raiz
```
reactive-api/
├─ .kiro/                     # Configuração do Kiro (steering, agents, hooks, specs, settings)
├─ .mvn/                      # Maven wrapper
├─ src/
│  ├─ main/
│  │  ├─ java/br/com/dataprev/alura/codechella/
│  │  └─ resources/
│  │     ├─ application.properties
│  │     └─ db/migration/      # Migrations Flyway (V<n>__descricao.sql)
│  └─ test/
│     └─ java/br/com/dataprev/alura/codechella/
├─ docker-compose.yml         # PostgreSQL local
├─ pom.xml
└─ mvnw / mvnw.cmd
```

## Pacote base
`br.com.dataprev.alura.codechella`

## Convenção de camadas (reativo)
Organize por camada dentro do pacote base. Sugestão de pacotes conforme o
domínio for crescendo:

```
codechella/
├─ ReactiveApiApplication.java   # Classe @SpringBootApplication (entrypoint)
├─ controller/                   # @RestController — handlers retornam Mono/Flux
├─ service/                      # Regras de negócio, orquestração reativa
├─ repository/                   # Interfaces ReactiveCrudRepository / R2DBC
├─ domain/ (ou model/)           # Entidades mapeadas (@Table) e records
├─ dto/                          # Objetos de request/response (records)
├─ mapper/                       # Conversão entidade <-> DTO
└─ config/                       # @Configuration, beans, customizações
```

## Convenções de código
- Entidades de domínio: anotadas com `@Table`, id com `@Id`.
- DTOs: prefira `record` imutável.
- Repositórios: estender `ReactiveCrudRepository<Entidade, Id>` ou
  `R2dbcRepository`.
- Nomes de métodos de controller retornam sempre `Mono<...>` ou `Flux<...>`.
- Nomes de classe em inglês ou português seguindo o que já existir no pacote;
  seja consistente com o código vizinho.

## Migrations
- Local: `src/main/resources/db/migration/`.
- Padrão de nome: `V<numero>__descricao_em_snake_case.sql` (ex.: `V2__cria_tabela_usuario.sql`).
- Numeração sequencial, nunca editar uma migration já aplicada — crie uma nova.

## Testes
- Espelham o pacote de produção em `src/test/java/...`.
- Use `StepVerifier` (Reactor Test) para validar pipelines reativos.
- Use `@WebFluxTest` para slices de controller e `WebTestClient` para endpoints.
