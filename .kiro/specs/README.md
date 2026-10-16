# Specs

Cada feature complexa vive em sua própria pasta aqui dentro, no formato
`.kiro/specs/<nome-da-feature>/`, com três arquivos que evoluem em sequência:

1. `requirements.md` — o quê e por quê. Histórias de usuário e critérios de
   aceitação (formato EARS: "QUANDO ... O SISTEMA DEVE ...").
2. `design.md` — como. Arquitetura, componentes, modelos de dados, fluxos
   reativos (`Mono`/`Flux`), tratamento de erros e estratégia de testes.
3. `tasks.md` — passos de implementação incrementais, cada um rastreável até um
   requisito.

## Fluxo de trabalho
Requisitos → Design → Tarefas → Implementação. Revise e aprove cada etapa antes
de avançar para a próxima.

## Como começar uma spec
Peça ao Kiro: "crie uma spec para a feature X". Ele vai gerar a pasta e os três
documentos iterativamente com você.

> As pastas de specs existentes são commitadas para documentar o histórico de
> design do projeto.
