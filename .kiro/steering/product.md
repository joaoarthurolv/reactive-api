---
inclusion: always
---

# Produto — reactive-api

## Visão geral
API reativa de estudo construída com Spring WebFlux, no contexto do curso
Codechella (Alura). O objetivo é explorar programação reativa de ponta a
ponta: da camada web (WebFlux) até o acesso a dados não bloqueante (R2DBC).

## Objetivos
- Praticar APIs reativas com backpressure e pipelines `Mono`/`Flux`.
- Manter o acesso a dados totalmente não bloqueante via R2DBC.
- Versionar o schema do banco com Flyway de forma incremental.

## Princípios de produto
- Preferir soluções simples e idiomáticas do ecossistema Spring reativo.
- Nunca introduzir chamadas bloqueantes no caminho da requisição.
- Expor endpoints coesos, previsíveis e bem tipados.
