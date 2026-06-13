# Validação de Coordenada por Bounding Box

> **Propósito**: Detectar coordenadas fora da área esperada sem descartar a linha
> **Validado**: 2026-06-13

## Quando usar

- Fontes com coordenadas sujas (pontos no oceano, hemisfério trocado, zeros)
- Quando a linha tem valor mesmo com geo ruim (outros campos são úteis)
- Antes de indexar H3 (não indexar lixo, mas não perder o registro)

## Implementação

```python
from pyspark.sql import functions as F

# Bounding box da área esperada (min/max de lat e lng do território de interesse).
# Definir como constante de projeto — aqui valores genéricos de exemplo.
LAT_MIN, LAT_MAX = -34.0, 5.3
LNG_MIN, LNG_MAX = -74.0, -34.0

df = df.withColumn("_coord_suspeita",
    ~( F.col("latitude").between(LAT_MIN, LAT_MAX)
     & F.col("longitude").between(LNG_MIN, LNG_MAX) )
    | F.col("latitude").isNull() | F.col("longitude").isNull())
# Princípio: FLAG, não DROP. A linha permanece; só o H3 fica nulo quando suspeita.
```

## Configuração

| Decisão | Recomendação |
|---------|--------------|
| Ação na suspeita | Flag booleana, preservar a linha (ver `qualidade-de-dados`) |
| Bbox | Min/max dos **extremos reais** do território (incl. ilhas/pontas) — um bbox curto demais gera falso-positivo em massa; largo demais não pega nada |
| Nulos | Tratar como suspeita (sem coordenada = sem validação possível) |
| Correção (geocoding) | Fora do escopo da validação; é outra etapa, opcional |

## Exemplo de uso

```python
# Métrica de qualidade: quantos pontos caíram fora da área esperada
suspeitas = df.filter(F.col("_coord_suspeita")).count()
# Esperado: número pequeno. Pico = problema na fonte, investigar.
```

## Ver também

- [indexacao-h3](indexacao-h3.md) — H3 nulo quando `_coord_suspeita`
- `qualidade-de-dados/concepts/quarentena-rejeicao-alerta.md` — flag vs drop vs quarentena
