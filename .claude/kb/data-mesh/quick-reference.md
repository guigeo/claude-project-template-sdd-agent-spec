# Data Mesh — Quick Reference

> Tabelas de consulta rápida. Exemplos nos arquivos linkados.

## Os 4 princípios

| Princípio | Em uma frase |
|-----------|--------------|
| Domain ownership | Quem conhece o dado é dono do dado — ponta a ponta |
| Data as a product | Dado publicado tem consumidor, contrato, qualidade e dono |
| Self-serve platform | Plataforma comum para criar produtos sem reinventar infra |
| Federated governance | Regras globais mínimas, decisões locais nos domínios |

## Checklist de um data product

| Atributo | Verificação |
|----------|-------------|
| Descobrível | Está no catálogo com descrição e dono |
| Endereçável | Nome estável (`catalogo.dominio.produto`) que não muda com refactors |
| Confiável | Qualidade declarada e medida (expectations + métricas) |
| Autodescritivo | Schema documentado, grão e semântica nos comentários |
| Interoperável | Chaves e dimensões conformadas entre domínios |
| Seguro | Acesso governado (grants explícitos por consumidor) |

## Anti-padrões

| Não faça | Faça |
|----------|------|
| Mesh como reorganização de pastas | Mesh é dono + contrato — sem dono, é só taxonomia |
| Um "domínio" por tabela | Domínio = área de negócio (licenciamento, cobertura), não entidade |
| Adotar federated governance com 1 time | Em time único: convenções escritas já são a governança |
| Expor tabela interna como produto | Produto é interface estável; internals podem mudar |
| Burocratizar projeto pequeno | Adotar princípios incrementalmente (ver mesh pragmático) |

## Documentação relacionada

| Tópico | Caminho |
|--------|---------|
| Princípios | `concepts/os-quatro-principios.md` |
| Escala pequena | `concepts/mesh-pragmatico-escala-pequena.md` |
| Índice completo | `index.md` |
