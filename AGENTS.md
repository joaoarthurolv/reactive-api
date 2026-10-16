# AGENTS.md

Instruções para agentes de IA e pessoas contribuindo neste repositório.
Mantenha este arquivo como a fonte de verdade para **organização de Git e
commits**. O contexto técnico do projeto fica em `.kiro/steering/`
(`tech.md`, `structure.md`, `product.md`).

## Sobre o projeto

- **reactive-api** — estudo de APIs reativas com Spring WebFlux.
- **Stack:** Java 21, Spring Boot 4.1.0, WebFlux (Netty), Spring Data R2DBC,
  Flyway e PostgreSQL.
- **Pacote base:** `br.com.dataprev.alura.codechella`.
- **Idioma:** código e documentação seguem o padrão em inglês para nomes
  técnicos; textos, comentários de negócio e mensagens de commit em
  **Português do Brasil**.

---

## Fluxo de branches (GitFlow)

Adotamos o modelo **GitFlow** como referência de organização. Em um projeto
de produção, a branch `main` representa o que está estável e receberia apenas
merges de `release/*` e `hotfix/*`.

> **Exceção — projeto de estudos.**
> Este repositório é um projeto de estudos. Por isso, **é permitido commitar
> diretamente na `main`**, sem a cerimônia de Pull Request. As demais branches
> do GitFlow continuam disponíveis como boa prática (ex.: agrupar uma feature
> maior em `feature/*`), mas não são obrigatórias.

| Branch      | Origem    | Destino do merge | Finalidade                                        |
| ----------- | --------- | ---------------- | ------------------------------------------------- |
| `main`      | —         | —                | Versão estável/entregue. Sempre "mergeável".       |
| `develop`   | `main`    | `release/*`      | Integração contínua das features prontas.          |
| `feature/*` | `develop` | `develop`        | Nova funcionalidade ou melhoria.                   |
| `release/*` | `develop` | `main` (vai pra prod) + `develop`        | Estabilização/preparo de uma versão.  |
| `hotfix/*`  | `main`    | `main` + `develop`                       | Correção urgente em produção.        |
| `bugfix/*`  | `develop` | `develop`        | Correção de bug que não é urgente.                 |

Migrations Flyway e novas versões podem gerar promoção via `release/*`.

### Regras

- Em produção, **não** commite direto em `main`/`develop` — use branches de
  trabalho e Pull Request. **Neste projeto de estudos, commit direto na `main`
  é permitido** (ver exceção acima).
- Toda feature sai de `develop` e volta para `develop` via merge/PR.
- `hotfix/*` sai de `main`, e ao final é mergeado em `main` (com tag) **e** em
  `develop` para não perder a correção.
- Mantenha as branches curtas e com escopo único.
- Após merge, apague a branch remota e local correspondente.

### Nomenclatura de branches

Formato: `<tipo>/<escopo-curto>` em minúsculas e `kebab-case`; inclua o número
da issue quando existir.

```text
feature/12-endpoint-agendamento
bugfix/45-corrige-null-ao-criar-evento
release/1.2.0
hotfix/1.1.1-corrige-timeout-r2dbc
chore/atualiza-dependencias
```

Prefixos aceitos: `feature`, `bugfix`, `hotfix`, `release`, `chore`, `docs`,
`refactor`.

---

## Padrão de commits (Conventional Commits)

Usamos **Conventional Commits** com descrição em **Português do Brasil**.

### Formato

```text
<tipo>(<escopo>): <descrição curta>

<corpo opcional — o que e por quê>

<rodapé opcional — refs, breaking changes>
```

- O `<escopo>` é opcional, mas recomendado (veja lista abaixo).
- A `<descrição curta>` usa o **imperativo, no presente**, em pt-BR
  (ex.: "adiciona", "corrige", "remove"), **sem ponto final**, com no máximo
  **72 caracteres**.
- Use o corpo para explicar **o porquê** da mudança quando não for óbvio.
  Quebre linhas em 72 colunas.
- **Um commit = uma mudança coesa.** Não misture refatoração com feature.
- Nunca inclua segredos (senhas, tokens) na mensagem ou no diff.

### Tipos

| Tipo       | Uso                                                            |
| ---------- | -------------------------------------------------------------- |
| `feat`     | Nova funcionalidade ou endpoint visível ao usuário.            |
| `fix`      | Correção de bug.                                               |
| `refactor` | Mudança de código sem alterar comportamento externo.           |
| `perf`     | Melhoria de desempenho (cuidado com bloqueio no caminho reativo). |
| `test`     | Adição ou ajuste de testes.                                    |
| `docs`     | Documentação (README, AGENTS.md, `.kiro/`).                    |
| `style`    | Formatação, espaços — sem mudança de lógica.                   |
| `chore`    | Build, dependências, configuração, ferramentas.                |
| `build`    | Mudanças no `pom.xml`/Maven.                                   |
| `ci`       | Pipelines e automações de integração.                          |
| `revert`   | Reversão de um commit anterior.                                |

### Escopos sugeridos

`controller`, `service`, `repository`, `domain`, `dto`, `mapper`, `config`,
`migration`, `db`, `docker`, `build`, `docs`.

### Exemplos

```text
feat(evento): adiciona endpoint POST /eventos com validação reativa

fix(repository): corrige consulta que retornava Flux vazio em erro de conexão

docs: documenta convenções de commit e gitflow no AGENTS.md

chore(deps): atualiza versão do r2dbc-postgresql no pom.xml

refactor(service): extrai mapeamento de DTO para classe Mapper

test(controller): cobre criação de evento com @WebFluxTest e StepVerifier
```

Rodapé para referenciar issues e breaking changes:

```text
feat(domain): substitui record Evento por entidade @Table

BREAKING CHANGE: o construtor de Evento passa a exigir o id.
Refs: #23
```

---

## Versionamento e releases

- Versionamento semântico (**SemVer**): `MAJOR.MINOR.PATCH`.
  - `MAJOR` — mudanças incompatíveis.
  - `MINOR` — nova funcionalidade compatível.
  - `PATCH` — correção compatível.
- Toda `release/*` finalizada em `main` recebe uma **tag anotada**:
  ```bash
  git tag -a v1.2.0 -m "Release 1.2.0"
  git push origin v1.2.0
  ```

---

## Checklist antes de commitar

1. Rode os testes: `./mvnw test` (ou `.\mvnw.cmd test` no Windows).
   - Para validar build completo: `./mvnw clean verify`.
2. Garanta que migrations Flyway seguem o padrão
   `V<n>__descricao_em_snake_case.sql` e não editam migrations já aplicadas.
3. Confirme que não há `.block()` nem I/O blocante no caminho reativo
   (ver `.kiro/steering/tech.md`).
4. Verifique que nenhum segredo/credencial entrou no diff.
5. Revise a mensagem de commit conforme o padrão acima.
6. Faça `pull`/rebase da branch base antes de abrir o Pull Request.

---

## Notas para agentes de IA

- Escreva **mensagens de commit em Português do Brasil**, seguindo o padrão
  deste documento.
- **Não** faça commit ou push direto em `main`/`develop` em contextos de
  produção. **Neste projeto de estudos isso é permitido.**
- Fora da exceção acima, proponha uma branch no padrão GitFlow antes de
  efetivar mudanças.
- Prefira diversos commits pequenos e coesos a um commit grande e misto.
- Não commite arquivos gerados (`target/`) — respeite o `.gitignore`.
