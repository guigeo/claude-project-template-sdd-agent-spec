# Os Quatro Princípios

> **Propósito**: Entender os pilares do data mesh e o problema que cada um resolve
> **Confiança**: 0.95
> **Validado**: 2026-06-10

## Visão geral

Data mesh (Zhamak Dehghani) responde à falha dos data lakes centralizados: um time
central que não conhece o negócio vira gargalo e produz dados sem dono. Os quatro
princípios se sustentam mutuamente — adotar só a "organização por domínio" sem
ownership e contrato reproduz o lake centralizado com pastas mais bonitas.

## O padrão

```text
1. DOMAIN OWNERSHIP        O time do domínio (ex.: licenciamento) é dono do dado
                           da ingestão ao serving — não joga "por cima do muro".

2. DATA AS A PRODUCT       Cada dataset publicado tem: dono, consumidores conhecidos,
                           contrato (schema + grão + SLA), qualidade declarada e medida.

3. SELF-SERVE PLATFORM     Infraestrutura comum (catálogo, pipelines, monitoração)
                           para que cada domínio publique produtos sem reinventar base.

4. FEDERATED GOVERNANCE    Regras globais mínimas e automatizadas (nomenclatura,
                           segurança, interoperabilidade); o resto decide-se no domínio.
```

## Referência rápida

| Princípio | Sintoma da ausência |
|-----------|--------------------|
| Domain ownership | "Esse dado está errado, mas não é comigo" |
| Data as a product | Consumidores quebram a cada refactor silencioso |
| Self-serve | Cada pipeline reinventa ingestão e monitoramento |
| Federated governance | Ou anarquia de padrões, ou comitê central que trava tudo |

## Erros comuns

### Errado

```text
"Implementamos data mesh: renomeamos os schemas para o nome dos departamentos."
```

### Correto

```text
Cada schema de domínio tem: dono nomeado, tabelas-produto com contrato documentado,
qualidade medida, e consumidores que sabem o que podem assumir.
```

## Relacionados

- [mesh-pragmatico-escala-pequena](mesh-pragmatico-escala-pequena.md)
- [data-product-e-contrato](../patterns/data-product-e-contrato.md)
