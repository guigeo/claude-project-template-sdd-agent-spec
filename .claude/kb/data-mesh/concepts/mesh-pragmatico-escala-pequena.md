# Mesh Pragmático em Escala Pequena

> **Propósito**: O que adotar do data mesh quando o "mesh" inteiro é um time (ou uma pessoa)
> **Confiança**: 0.90
> **Validado**: 2026-06-10

## Visão geral

Data mesh foi desenhado para organizações com muitos times; aplicá-lo literalmente a um
projeto solo é burocracia. Mas dois princípios pagam dividendos em qualquer escala:
**organizar por domínio de negócio** (em vez de por tecnologia ou origem) e **tratar
saídas como produto** (contrato explícito mesmo que o consumidor seja você no futuro).

## O padrão

```text
ADOTE desde o dia 1 (custo ~zero, valor alto):
  • Schemas/catálogo organizados por domínio de negócio, não por fonte
  • Toda tabela Gold com: comentário de semântica, grão, dono e SLA
  • Qualidade declarada (expectations) nas tabelas-produto

ADIE até existirem 2+ times/domínios de verdade:
  • Governança federada formal (em time único: convenções no CLAUDE.md/README)
  • Plataforma self-serve dedicada (a própria cloud gerenciada já cumpre o papel)
  • Processos de descoberta entre domínios

RESULTADO: quando o projeto crescer, as fronteiras já existem —
promover um domínio a "time dono" não exige reescrever nada.
```

## Referência rápida

| Escala | Forma do mesh |
|--------|---------------|
| 1 pessoa / 1 time | Domínios como schemas + contratos nas tabelas Gold |
| 2-5 times | + donos nomeados por domínio, convenções globais escritas |
| Muitos times | Mesh completo: governança federada, plataforma self-serve |

## Erros comuns

### Errado

```text
Projeto solo criando "comitê de governança", templates de RFC e processo de
aprovação entre domínios — teatro organizacional sem organização.
```

### Correto

```text
Projeto solo com schemas por domínio, contrato documentado nas tabelas-produto
e qualidade medida. O resto do mesh entra quando entrar gente.
```

## Relacionados

- [os-quatro-principios](os-quatro-principios.md)
- [data-product-e-contrato](../patterns/data-product-e-contrato.md)
