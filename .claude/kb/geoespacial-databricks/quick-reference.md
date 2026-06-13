# Geoespacial no Databricks — Quick Reference

> Tabelas de consulta rápida. Exemplos nos arquivos linkados.

## Funções H3 comuns

| Função | Uso |
|--------|-----|
| `h3_longlatash3(lng, lat, res)` | Coordenada → índice H3 (bigint) na resolução `res` |
| `h3_isvalid(h3)` | Valida um índice H3 |
| `h3_h3tostring(h3)` | bigint → string hex do H3 |
| `h3_kring(h3, k)` | Células vizinhas (anel k) — busca de proximidade |
| `h3_toparent(h3, res)` | Sobe para resolução menor (agregação) |

## Resoluções H3 (referência)

| res | Aresta aprox. | Bom para |
|-----|---------------|----------|
| 6 | ~3 km | Agregação regional grossa |
| 8 | ~460 m | Cobertura urbana / bairro (default comum) |
| 9 | ~170 m | Análise fina |

## Matriz de decisão

| Necessidade | Escolha |
|-------------|---------|
| Indexar e agregar pontos por célula | Coluna H3 `bigint` persistida |
| Distância/contém/interseção pontual | Funções `ST_*` on-the-fly (não persistir tipo) |
| Persistir geometria na Free Edition | **Não dá** — usar `double` (lat/lng) + H3 |
| Busca de vizinhança | `h3_kring` sobre a coluna H3 |

## Limites e pitfalls

| Não faça | Faça |
|----------|------|
| Persistir coluna `GEOMETRY`/`GEOGRAPHY` na Free Edition | `double` + H3; `ST_` só em tempo de consulta |
| Indexar H3 com lat/lng ainda em `string` | Cast defensivo para `double` antes (ver KB pyspark) |
| Dropar ponto com coordenada suspeita | Flag `_coord_suspeita`, preservar a linha |
| `h3_longlatash3(lat, lng, ...)` (ordem trocada) | Ordem é **(longitude, latitude, resolução)** |

## Documentação relacionada

| Tópico | Caminho |
|--------|---------|
| Tipos e limites | `concepts/tipos-e-limites-geoespaciais.md` |
| Indexação H3 | `patterns/indexacao-h3.md` |
| Índice completo | `index.md` |
