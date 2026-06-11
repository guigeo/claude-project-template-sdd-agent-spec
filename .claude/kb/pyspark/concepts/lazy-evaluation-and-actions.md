# Lazy Evaluation and Actions

> **Purpose**: Understand why transformations build a plan and only actions execute it
> **Confidence**: 0.95
> **Validated**: 2026-06-10 (API stable since Spark 2.x)

## Overview

Transformations (`select`, `filter`, `join`, `groupBy`...) are lazy: they only build a logical plan.
Execution happens when an action runs (`count`, `collect`, `show`, `write`). Each action triggers
a full job over the lineage — repeating actions repeats the computation unless you cache.

## The Pattern

```python
from pyspark.sql import functions as F

df = (spark.read.table("bronze.events")
      .filter(F.col("event_date") >= "2026-01-01")
      .select("id", "event_type", "payload"))   # nothing executed yet

df_clean = df.dropDuplicates(["id"])             # still nothing

df_clean.write.mode("overwrite").saveAsTable("silver.events")  # ACTION: one job runs
```

## Quick Reference

| Call | Kind | Triggers job? |
|------|------|---------------|
| `filter`, `select`, `join`, `groupBy().agg` | Transformation | No |
| `count()`, `collect()`, `show()`, `first()` | Action | Yes |
| `write.*`, `foreach` | Action | Yes |
| `cache()` / `persist()` | Hint | No (materializes on next action) |

## Common Mistakes

### Wrong

```python
print(df.count())          # job 1
df_ok = df.filter(...)
print(df_ok.count())       # job 2 — recomputes everything from source
df_ok.write.saveAsTable("t")  # job 3 — recomputes again
```

### Correct

```python
df_ok = df.filter(...).cache()
n = df_ok.count()          # materializes the cache
df_ok.write.saveAsTable("t")  # reuses cached data
df_ok.unpersist()
```

## Related

- [performance-essentials](../patterns/performance-essentials.md)
- [joins-and-strategies](joins-and-strategies.md)
