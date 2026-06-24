# Mart sobre Mart (reconciliação por construção)

> **Propósito**: Reaproveitar uma definição de estado já centralizada, em vez de re-derivá-la em cada mart nova
> **Validado**: 2026-06-24

## Quando usar

- Já existe um mart Gold que centraliza um estado canônico de uma entidade
  (ex.: "ativo", "vigente", "corrente" — qualquer filtro que define o
  subconjunto "que conta" hoje)
- Uma nova mart precisa do mesmo subconjunto de entidades, só agregado por
  outra dimensão (outra geografia, outra categoria, outro recorte temporal)
- A regra desse estado tem lógica não trivial (ex.: depende de uma janela
  dinâmica, de um `DENSE_RANK`, de comparação entre snapshots) — duplicá-la
  é risco de divergência

## Implementação

```text
ERRADO — re-derivar o estado a partir da camada crua em cada mart nova:

  silver.entities ──▶ gold.entities_by_region   (re-calcula "ativo" aqui)
                  ──▶ gold.entities_by_category  (re-calcula "ativo" aqui)

  Duas implementações da mesma regra = duas chances de divergir.

CERTO — ler do mart que já centraliza o estado:

  silver.entities ──▶ gold.entities_status        (define "ativo" 1x)
                            │  WHERE status = 'active'
                            ├──▶ gold.entities_by_region
                            └──▶ gold.entities_by_category

  O total de cada mart derivada reconcilia exatamente com gold.entities_status
  "por construção" — não precisa de query de reconciliação manual, porque as
  duas leem da mesma fonte com o mesmo filtro.
```

## Configuração

| Decisão | Padrão recomendado |
|---------|--------------------|
| Onde materializar a mart derivada | Mesmo pipeline declarativo da mart de origem — o motor resolve a ordem pelo DAG (não precisa orquestrar manualmente) |
| Acoplamento | Aceitável e intencional: a mart derivada depende da mart de origem estar atualizada primeiro |
| Quando NÃO aplicar | Se a mart derivada precisa de um estado diferente do já centralizado (ex.: "ativo nos últimos 30 dias" quando o mart de origem só tem "ativo agora") — duplicar a regra com a variação explícita, não forçar reuso |

## Exemplo de uso

```sql
-- gold.entities_status já resolve "ativo" via janela dinâmica (ex.: snapshot mais recente)
CREATE MATERIALIZED VIEW gold.entities_by_region AS
SELECT region, COUNT(*) AS qtd_active
FROM gold.entities_status
WHERE status = 'active'
GROUP BY region;
-- soma(qtd_active) = COUNT(*) de gold.entities_status WHERE status='active', sempre
```

## Ver também

- [modelagem-silver-e-gold](modelagem-silver-e-gold.md)
- [idempotencia-e-reprocessamento](../concepts/idempotencia-e-reprocessamento.md)
