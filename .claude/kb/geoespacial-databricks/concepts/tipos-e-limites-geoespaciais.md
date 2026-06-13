# Tipos e Limites Geoespaciais

> **Propósito**: Escolher como persistir dados espaciais no Databricks, respeitando os limites de tipo
> **Confiança**: 0.95
> **Validado**: 2026-06-13 (limite da Free Edition comprovado em uso real: `UNSUPPORTED_DATATYPE`)

## Visão geral

O Databricks oferece três formas de lidar com geo: colunas numéricas (`double` lat/lng),
índice hierárquico **H3** (`bigint`) e tipos nativos `GEOMETRY`/`GEOGRAPHY` com funções `ST_*`.
A escolha não é só de conveniência: **a Free Edition não persiste `GEOMETRY`/`GEOGRAPHY`**
(falha com `UNSUPPORTED_DATATYPE` ao gravar). O padrão robusto e portável é persistir
`double` + H3 e usar `ST_*` apenas on-the-fly em consultas.

## O padrão

```sql
-- Persistir: double (coordenada) + H3 (índice de agregação). Portável, inclusive Free Edition.
SELECT
  latitude,                                  -- double
  longitude,                                 -- double
  h3_longlatash3(longitude, latitude, 8) AS h3_res8   -- bigint, índice persistível
FROM pontos;

-- ST_* só em tempo de consulta (NÃO gravar coluna GEOMETRY na Free Edition):
SELECT ST_Distance(ST_Point(lng_a, lat_a), ST_Point(lng_b, lat_b)) AS dist
FROM pares;
```

## Referência rápida

| Forma | Persiste? | Free Edition | Uso |
|-------|-----------|--------------|-----|
| `double` lat/lng | Sim | OK | Base de tudo |
| H3 `bigint` | Sim | OK | Indexação e agregação espacial |
| `GEOMETRY`/`GEOGRAPHY` | Sim (em edições pagas) | **Não** (`UNSUPPORTED_DATATYPE`) | Evitar persistir |
| `ST_*` em query | n/a | OK | Distância/contém/interseção pontual |

## Erros comuns

### Errado

```sql
CREATE TABLE pontos AS
SELECT ST_Point(longitude, latitude) AS geom FROM origem;  -- falha na Free Edition
```

### Correto

```sql
CREATE TABLE pontos AS
SELECT longitude, latitude,
       h3_longlatash3(longitude, latitude, 8) AS h3_res8   -- persistível em qualquer edição
FROM origem;
```

## Relacionados

- [indexacao-h3](../patterns/indexacao-h3.md)
- [validacao-coordenada-bbox](../patterns/validacao-coordenada-bbox.md)
