# Geoespacial no Databricks — Domínio KB

> Indexação espacial, tipos geoespaciais e validação de coordenadas no Databricks.
> Destilado de uso real; agnóstico de projeto.

## Quando carregar este domínio

- Persistir coordenadas e indexá-las para agregação por região
- Decidir entre H3, colunas `double` e tipos `GEOMETRY`/`GEOGRAPHY`
- Validar coordenadas (pontos fora da área esperada)
- Trabalhar dentro dos limites de tipo do Databricks Free Edition

## Arquivos

| Arquivo | O que responde |
|---------|----------------|
| [quick-reference.md](quick-reference.md) | Funções H3/ST_, matriz de decisão, limites |
| [concepts/tipos-e-limites-geoespaciais.md](concepts/tipos-e-limites-geoespaciais.md) | H3 vs GEOMETRY/GEOGRAPHY; o que persiste na Free Edition |
| [patterns/indexacao-h3.md](patterns/indexacao-h3.md) | Coluna H3 persistida para agregação espacial |
| [patterns/validacao-coordenada-bbox.md](patterns/validacao-coordenada-bbox.md) | Flag de coordenada fora do bounding box (sem dropar) |

## Domínios relacionados

- `databricks-lakeflow/` — limites gerais do Free Edition
- `qualidade-de-dados/` — princípio "flag, não drop" aplicado a coordenadas
- `pyspark/` — cast defensivo das coordenadas de texto para `double`
