# Reading and Writing Files (CSV / Excel / Parquet / Delta)

> **Purpose**: Production file IO with explicit schemas and safe write modes
> **Validated**: 2026-06-10

## When to Use

- Ingesting raw CSV/Excel drops into Bronze
- Persisting curated tables as Delta
- Exchanging columnar data as Parquet

## Implementation

```python
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, DateType

# --- CSV: always explicit schema in production ---
schema = StructType([
    StructField("station_id", StringType(), False),
    StructField("latitude",   DoubleType(), True),
    StructField("longitude",  DoubleType(), True),
    StructField("issue_date", DateType(),  True),
])

df = (spark.read.format("csv")
      .option("header", "true")
      .option("sep", ";")              # BR public data often uses ';'
      .option("encoding", "ISO-8859-1") # and latin-1 encoding
      .schema(schema)
      .load("/Volumes/cat/schema/raw/file.csv"))

# --- Excel: no native Spark reader. Convert via pandas, then createDataFrame ---
import pandas as pd
pdf = pd.read_excel("/Volumes/cat/schema/raw/file.xlsx", dtype=str)  # openpyxl required
df_xl = spark.createDataFrame(pdf)

# --- Delta (default sink) ---
(df.withColumn("_ingested_at", F.current_timestamp())
   .write.format("delta").mode("append").saveAsTable("bronze.stations"))

# --- Parquet (interchange only; prefer Delta for tables) ---
df.write.mode("overwrite").parquet("/Volumes/cat/schema/export/stations/")
```

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| `header` | `false` | CSV first line as column names |
| `mode` (read) | `PERMISSIVE` | Use with `columnNameOfCorruptRecord` to capture bad rows |
| `mergeSchema` | `false` | Parquet/Delta read across schema versions |
| write `mode` | `errorifexists` | `append` for incremental, `overwrite` for full refresh |

## Example Usage

```python
# Capture malformed CSV rows instead of dropping silently
df = (spark.read.format("csv").schema(schema)
      .option("header", "true")
      .option("mode", "PERMISSIVE")
      .option("columnNameOfCorruptRecord", "_corrupt")
      .load(path))
bad = df.filter(F.col("_corrupt").isNotNull())   # route to quarantine
```

## See Also

- [performance-essentials](performance-essentials.md)
- [lazy-evaluation-and-actions](../concepts/lazy-evaluation-and-actions.md)
