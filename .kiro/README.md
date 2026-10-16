# Configuração do Kiro — reactive-api

Esta pasta contém tudo que o Kiro usa para assistir o desenvolvimento deste
projeto. Estrutura:

```
.kiro/
├─ steering/     # Contexto e regras injetados nas conversas
│  ├─ product.md    # Visão de produto (inclusion: always)
│  ├─ tech.md       # Stack técnica e regras do reativo (inclusion: always)
│  ├─ structure.md  # Estrutura de pastas e convenções (inclusion: always)
│  └─ git.md        # GitFlow, padrão de commits e versionamento (inclusion: always)
├─ agents/       # Agentes customizados
│  ├─ migration-author.json   # Cria/valida migrations Flyway
│  └─ reactive-reviewer.json  # Revisa código reativo (WebFlux/R2DBC/Reactor)
├─ hooks/        # Automações disparadas por eventos
│  ├─ build-on-java-save.json       # Compila ao salvar .java
│  └─ validate-flyway-migration.json # Valida migration recém-criada
├─ specs/        # Specs de features (requirements → design → tasks)
└─ settings/     # Configurações locais (ex.: mcp.json)
```

## Steering
Os arquivos em `steering/` com `inclusion: always` entram em toda interação.
Você pode criar outros com:
- `inclusion: fileMatch` + `fileMatchPattern` — incluído só quando um arquivo
  correspondente entra no contexto.
- `inclusion: manual` — incluído só quando referenciado com `#` no chat.
- `inclusion: auto` + `name` + `description` — ativado sob demanda quando o
  pedido casa com a descrição.

## Agentes
Invoque um agente customizado para tarefas especializadas. Edite os `.json`
em `agents/` para ajustar prompt e ferramentas permitidas.

## Hooks
Disparam comandos ou prompts em eventos (salvar/criar arquivo, etc.). Ativam no
próximo início de sessão. Edite os `.json` em `hooks/` para ajustar.

## MCP (Model Context Protocol)
Para adicionar servidores MCP, crie `.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "exemplo": {
      "command": "uvx",
      "args": ["pacote-do-servidor@latest"],
      "env": { "FASTMCP_LOG_LEVEL": "ERROR" },
      "disabled": false
    }
  }
}
```

Também é possível configurar MCP no nível do usuário em
`~/.kiro/settings/mcp.json`.
