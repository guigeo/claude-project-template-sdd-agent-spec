# Performance Essentials

> **Purpose**: The 20% of tuning that solves 80% of slow PySpark jobs
> **Validated**: 2026-06-10

## When to Use

- A job is slow, spilling, or producing thousands of tiny files
- Reviewing PySpark code before it reaches production
- Deciding between a UDF and native functions

## Implementation

```python
from pyspark.sql import functions as F

# 1. Native functions over UDFs — Catalyst can't optimize Python UDFs
df = df.withColumn("clean_name", F.upper(F.trim("name")))          # good
# df = df.withColumn("clean_name", my_python_udf("name"))          # last resort

# 2. If a UDF is unavoidable, vectorize it
from pyspark.sql.functions import pandas_udf
@pandas_udf("double")
def normalize(v: "pd.Series") -> "pd.Series":
    return (v - v.mean()) / v.std()

# 3. Control output file count (avoid small-files problem)
(df.repartition(8)                       # ~128MB-1GB per output file is healthy
   .write.format("delta").mode("overwrite").saveAsTable("silver.t"))

# 4. Filter and select EARLY — less data through every shuffle
df = (spark.read.table("bronze.big")
      .select("id", "k", "v")            # column pruning
      .filter(F.col("k") == "BR"))       # predicate pushdown

# 5. Inspect before guessing
df.explain(mode="formatted")             # look for: Exchange (shuffle), BroadcastHashJoin
```

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `spark.sql.adaptive.enabled` | `true` (3.2+) | AQE: runtime join strategy, skew split, partition coalescing |
| `spark.sql.shuffle.partitions` | `200` (auto w/ AQE) | Rarely hand-tune when AQE is on |
| `spark.sql.autoBroadcastJoinThreshold` | `10MB` | Raise cautiously for bigger dims |

## Example Usage

```python
# Symptom → first move
# Thousands of small output files  → repartition()/optimizeWrite before write
# One task much slower than rest   → key skew: check groupBy/join keys, AQE skew join
# Driver OOM                       → someone collect()ed; aggregate in Spark instead
# Slow row-by-row logic            → replace Python UDF with F.* functions
```

## See Also

- [lazy-evaluation-and-actions](../concepts/lazy-evaluation-and-actions.md)
- [joins-and-strategies](../concepts/joins-and-strategies.md)
