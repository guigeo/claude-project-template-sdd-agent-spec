# Lógica Pura Testável + Aplicação Nativa

> **Purpose**: Tornar regras de transformação testáveis com pytest sem abrir mão de performance (sem UDF)
> **Validated**: 2026-06-13

## When to Use

- Regras de limpeza/normalização que merecem teste unitário
- Quer cobertura pytest sem subir Spark a cada teste
- Tentação de usar UDF para "encapsular a regra" — evitável

## Implementation

```python
# 1. A REGRA em Python puro (sem Spark) — rápida de testar com pytest.
#    Constantes ficam aqui: FONTE ÚNICA DA VERDADE.
ALIASES: dict[str, str] = {"NOME LONGO LTDA": "NOME"}

def normaliza(bruto: str | None) -> str | None:
    if bruto is None:
        return None
    chave = " ".join(bruto.split()).upper()
    return ALIASES.get(chave, chave) or None

# test_regra.py  →  assert normaliza("nome longo ltda ") == "NOME"   (sem Spark)

# 2. A APLICAÇÃO no pipeline: expressão de coluna NATIVA (CASE/when), não UDF.
#    Reusa o MESMO dict — a regra não é reescrita, só traduzida para Column.
from pyspark.sql import functions as F, Column

def normaliza_col(c: Column) -> Column:
    base = F.regexp_replace(F.trim(F.upper(c)), r"\s+", " ")
    out = base
    for origem, destino in ALIASES.items():          # mesma constante do passo 1
        out = F.when(base == F.lit(origem), F.lit(destino)).otherwise(out)
    return F.when(base == F.lit(""), None).otherwise(out)
```

## Configuration

| Decisão | Recomendação |
|---------|--------------|
| Onde mora a constante | No módulo puro; o pipeline importa (uma definição só) |
| UDF | Evitar — Catalyst não otimiza; `when/otherwise` nativo é mais rápido |
| O que testar com pytest | A função pura; a tradução para `Column` é mecânica |
| Quando UDF é inevitável | `pandas_udf` (vetorizado), nunca UDF Python linha-a-linha |

## Example Usage

```python
df = df.withColumn("nome", normaliza_col(F.col("nome")))   # regra testada, sem UDF
```

## See Also

- [casting-defensivo](casting-defensivo.md)
- [performance-essentials](performance-essentials.md)
