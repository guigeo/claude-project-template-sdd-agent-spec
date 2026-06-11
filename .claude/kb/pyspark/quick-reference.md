# PySpark Quick Reference

> Fast lookup tables. For code examples, see linked files.

## Common operations

| Task | API | Notes |
|------|-----|-------|
| Select/rename | `df.select(F.col("a").alias("b"))` | Prefer `F.col` over strings in expressions |
| Filter | `df.filter(F.col("x") > 1)` | `where` is an alias |
| Aggregate | `df.groupBy("k").agg(F.sum("v"))` | Always alias aggregated columns |
| Dedupe | `df.dropDuplicates(["key"])` | Non-deterministic row kept — sort first if it matters |
| Window | `F.row_number().over(Window.partitionBy("k").orderBy("ts"))` | Standard "latest record" idiom |
| New column | `df.withColumn("y", expr)` | Chain few; use `select` for many columns |

## Decision Matrix

| Use Case | Choose |
|----------|--------|
| Small dim table joined to large fact | `F.broadcast(dim)` join |
| Custom row logic | Native functions first; UDF only as last resort |
| UDF unavoidable | `pandas_udf` (vectorized) over plain Python UDF |
| Iterating column list transforms | `select` with list comprehension, not chained `withColumn` |
| Need row count for logging | Count once, store result — every `count()` is a job |

## Common Pitfalls

| Don't | Do |
|-------|-----|
| `df.collect()` on large data | `df.limit(n).collect()` or write to a table |
| Infer schema on CSV in production | Declare an explicit `StructType` schema |
| Plain Python UDF for string/date math | Use `pyspark.sql.functions` equivalents |
| Many small output files | `df.repartition(n)` or Delta `optimizeWrite` before write |
| `cache()` everything | Cache only DataFrames reused 2+ times; `unpersist()` after |
| Cross join by accident (missing join key) | Always pass explicit `on=` and check the plan |

## Related Documentation

| Topic | Path |
|-------|------|
| Lazy evaluation | `concepts/lazy-evaluation-and-actions.md` |
| Joins | `concepts/joins-and-strategies.md` |
| File IO | `patterns/reading-writing-files.md` |
| Full Index | `index.md` |
