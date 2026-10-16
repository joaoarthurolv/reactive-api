---
inclusion: always
---

# Organização de Git e commits

Regras de GitFlow e de mensagens de commit. Fonte completa e canônica em
`/AGENTS.md` na raiz; este arquivo resume para injeção nas conversas.

> **Exceção — projeto de estudos.** Este repositório é de estudos, então
> **commitar direto na `main` é permitido**, sem Pull Request. O GitFlow abaixo
> é referência de organização; as branches não são obrigatórias.

## Fluxo de branches (GitFlow)

| Branch      | Origem    | Destino do merge          | Finalidade                       |
| ----------- | --------- | ------------------------- | -------------------------------- |
| `main`      | —         | —                         | Versão estável/entregue.         |
| `develop`   | `main`    | `release/*`               | Integração contínua das features.|
| `feature/*` | `develop` | `develop`                 | Nova funcionalidade/melhoria.    |
| `release/*` | `develop` | `main` + `develop`        | Estabilização/preparo de versão. |
| `hotfix/*`  | `main`    | `main` + `develop`        | Correção urgente em produção.    |
| `bugfix/*`  | `develop` | `develop`                 | Correção de bug não urgente.     |

- Em produção, não commitar direto em `main`/`develop`; usar branches + PR.
- `hotfix/*` sai de `main` e volta para `main` (com tag) **e** `develop`.
- Branches curtas, escopo único; apagar a branch após o merge.

### Nomenclatura de branches

`<tipo>/<escopo-curto>`, minúsculas, `kebab-case`, com número da issue quando
houver.

```text
feature/12-endpoint-agendamento
bugfix/45-corrige-null-ao-criar-evento
release/1.2.0
hotfix/1.1.1-corrige-timeout-r2dbc
chore/atualiza-dependencias
```

Prefixo aceitos: `feature`, `bugfix`, `hotfix`, `release`, `chore`, `docs`,
`refactor`.

## Padrão de commits (Conventional Commits)

Formato (descrição em **Português do Brasil**):

```text
<tipo>(<escopo>): <descrição curta>

<corpo opcional — o que e por quê>

<rodapé opcional — refs, breaking changes>
```

- `<escopo>` é opcional, mas recomendado.
- Descrição no **imperativo/presente**, em pt-BR ("adiciona", "corrige",
  "remove"), **sem ponto final**, até **72 caracteres**.
- Um commit = uma mudança coesa; não misturar refatoração com feature.
- Nunca incluir segredos na mensagem nem no diff.

### Tipos

| Tipo       | Uso                                                              |
| ---------- | ---------------------------------------------------------------- |
| `feat`     | Nova funcionalidade ou endpoint visível ao usuário.              |
| `fix`      | Correção de bug.                                                 |
| `refactor` | Mudança de código sem alterar comportamento externo.             |
| `perf`     | Melhoria de desempenho (sem bloquear o caminho reativo).         |
| `test`     | Adição ou ajuste de testes.                                      |
| `docs`     | Documentação (README, AGENTS.md, `.kiro/`).                      |
| `style`    | Formatação, espaços — sem mudança de lógica.                     |
| `chore`    | Build, dependências, configuração, ferramentas.                  |
| `build`    | Mudanças no `pom.xml`/Maven.                                     |
| `ci`       | Pipelines e automações de integração.                            |
| `revert`   | Reversão de um commit anterior.                                  |

### Escopos sugeridos

`controller`, `service`, `repository`, `domain`, `dto`, `mapper`, `config`,
`migration`, `db`, `docker`, `build`, `docs`.

### Exemplos

```text
feat(evento): adiciona endpoint POST /eventos com validação reativa

fix(repository): corrige consulta que retornava Flux vazio em erro de conexão

docs: documenta convenções de commit e gitflow no AGENTS.md

chore(deps): atualiza versão do r2dbc-postgresql no pom.xml

test(controller): cobre criação de evento com @WebFluxTest e StepVerifier
```

Breaking change e referência de issue:

```text
feat(domain): substitui record Evento por entidade @Table

BREAKING CHANGE: o construtor de Evento passa a exigir o id.
Refs: #23
```

## Versionamento e releases

- **SemVer**: `MAJOR.MINOR.PATCH` (incompatível / funcionalidade / correção).
- Finalizar `release/*` em `main` recebe **tag anotada**:
  ```bash
  git tag -a v1.2.0 -m "Release 1.2.0"
  git push origin v1.2.0
  ```

## Checklist antes de commitar

1. Rodar testes: `./mvnw test` (ou `.\mvnw.cmd test` no Windows); build
   completo com `./mvnw clean verify`.
2. Migrations Flyway no padrão `V<n>__descricao_em_snake_case.sql`, sem editar
   migrations já aplicadas.
3. Sem `.block()` nem I/O blocante no caminho reativo (ver `tech.md`).
4. Nenhum segredo/credencial no diff.
5. Mensagem de commit conforme o padrão acima.

## Notas para agentes

- Escrever mensagens de commit em **Português do Brasil**.
- Em projetos de produção, não commitar direto em `main`/`develop`; aqui
  (projeto de estudos) é permitido.
- Preferir commits pequenos e coesos; não commitar `target/` (respeitar o
  `.gitignore`).
