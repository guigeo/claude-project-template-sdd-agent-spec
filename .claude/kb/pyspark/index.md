# PySpark — KB Domain

> General PySpark DataFrame API knowledge for batch data engineering.
> Spark 3.5+ / 4.0. Project-agnostic — no business context.

## When to load this domain

- Writing or reviewing PySpark transformations
- Choosing join strategies or debugging shuffles
- Reading/writing CSV, Excel, Parquet, Delta
- Deciding between native functions and UDFs

## Files

| File | What it answers |
|------|-----------------|
| [quick-reference.md](quick-reference.md) | Fast lookup: common ops, decision matrix, pitfalls |
| [concepts/lazy-evaluation-and-actions.md](concepts/lazy-evaluation-and-actions.md) | Why nothing runs until an action; caching |
| [concepts/joins-and-strategies.md](concepts/joins-and-strategies.md) | Join types, broadcast vs shuffle, skew |
| [patterns/reading-writing-files.md](patterns/reading-writing-files.md) | CSV/Excel/Parquet/Delta IO with schemas |
| [patterns/performance-essentials.md](patterns/performance-essentials.md) | Partitioning, native functions vs UDF, AQE |
| [patterns/casting-defensivo.md](patterns/casting-defensivo.md) | Texto sujo → tipos: vírgula decimal, zero à esquerda, multivalor→array |

## Related domains

- `delta-lake/` — table format used as the default sink
- `databricks-lakeflow/` — declarative pipelines on top of PySpark
- `arquitetura-medalhao/` — where transformations live per layer
