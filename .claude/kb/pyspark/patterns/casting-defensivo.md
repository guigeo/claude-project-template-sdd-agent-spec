# Casting Defensivo

> **Propósito**: Converter dados de texto sujos (origem pública/legada) para tipos corretos sem corromper valores
> **Validado**: 2026-06-13

## When to Use

- Bronze chega tudo como `string` (CSV/XLS/exportações)
- Números com vírgula decimal, códigos com zero à esquerda, campos multivalor
- Antes de modelar a Silver — cast errado aqui contamina tudo a jusante

## Implementation

```python
from pyspark.sql import functions as F

df = (df
    # 1. Número com vírgula decimal (locale BR/EU) → double
    .withColumn("latitude",
        F.regexp_replace("latitude", ",", ".").cast("double"))

    # 2. Código identificador → MANTER string (cast int come o zero à esquerda)
    #    "0123456" como int viraria 123456. Código não é número: é string.
    .withColumn("cod_ibge", F.col("cod_ibge").cast("string"))

    # 3. Campo multivalor num único texto → array<string>
    #    "2G 4G "  → ["2G","4G"]   (split, trim, remove vazios)
    .withColumn("tecnologias",
        F.array_compact(                        # remove nulls
            F.transform(
                F.split(F.trim("tecnologias"), r"\s+"),
                lambda x: F.nullif(F.trim(x), F.lit("")))))

    # 4. Data em texto → date com formato explícito (nunca cast implícito)
    .withColumn("data_ref", F.to_date("data_ref", "yyyy-MM-dd")))
```

## Configuration

| Armadilha | Regra |
|-----------|-------|
| Vírgula decimal | `regexp_replace(",", ".")` antes do cast para `double` |
| Zero à esquerda (CEP, IBGE, conta) | Manter `string` — nunca cast numérico |
| Separador de multivalor | Confirmar no profiling (espaço? `;`? `\|`?) antes do `split` |
| Cast que falha silenciosamente | Cast inválido vira `null` — contar nulos pós-cast para detectar |
| Datas | `to_date`/`to_timestamp` com formato explícito, não cast direto |

## Example Usage

```python
# Validar que o cast não perdeu dados: nulos antes vs depois
antes = df.filter(F.col("latitude_raw").isNotNull()).count()
depois = df.filter(F.col("latitude").isNotNull()).count()
assert antes == depois, f"cast perdeu {antes - depois} coordenadas"
```

## See Also

- [reading-writing-files](reading-writing-files.md)
- `qualidade-de-dados/concepts/dimensoes-de-qualidade.md` — validade pós-cast
