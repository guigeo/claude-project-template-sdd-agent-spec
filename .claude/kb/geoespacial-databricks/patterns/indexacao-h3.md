# Indexação H3

> **Propósito**: Persistir um índice espacial H3 para agregar e buscar pontos por região
> **Validado**: 2026-06-13

## Quando usar

- Agregar pontos por célula geográfica (cobertura, densidade por área)
- Busca de proximidade (vizinhos de uma célula)
- Indexação espacial portável (funciona inclusive na Free Edition)

## Implementação

```python
from pyspark.sql import functions as F

# Pré-requisito: latitude/longitude já em double (ver KB pyspark, casting defensivo)
silver = (bronze
    .withColumn("latitude",  F.col("latitude").cast("double"))
    .withColumn("longitude", F.col("longitude").cast("double"))
    # H3 só quando a coordenada é válida; senão fica nulo (não inventa posição)
    .withColumn("h3_res8",
        F.when(F.col("_coord_suspeita") == False,
               F.expr("h3_longlatash3(longitude, latitude, 8)"))
         .otherwise(F.lit(None).cast("bigint"))))
```

```sql
-- Agregação por célula H3 (ex.: contagem por área)
SELECT h3_res8, count(*) AS qtd
FROM silver
WHERE h3_res8 IS NOT NULL
GROUP BY h3_res8;

-- Agregar para resolução menor (zoom out)
SELECT h3_toparent(h3_res8, 6) AS h3_res6, count(*) AS qtd
FROM silver GROUP BY 1;
```

## Configuração

| Parâmetro | Recomendação |
|-----------|--------------|
| Ordem dos args | `h3_longlatash3(longitude, latitude, resolução)` — lng primeiro |
| Resolução | 8 (~460 m) é um default urbano comum; ajustar ao grão de análise |
| Coordenada inválida | H3 nulo, não 0 — preserva semântica de "sem posição" |
| Tipo da coluna | `bigint` (mais leve); converter para string só na exibição |

## Exemplo de uso

```sql
-- Busca de vizinhança: células no anel k=1 ao redor de uma célula
SELECT explode(h3_kring(:h3_alvo, 1)) AS h3_vizinho;
```

## Ver também

- [tipos-e-limites-geoespaciais](../concepts/tipos-e-limites-geoespaciais.md)
- [validacao-coordenada-bbox](validacao-coordenada-bbox.md)
