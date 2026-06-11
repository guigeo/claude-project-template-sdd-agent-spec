# Joins and Join Strategies

> **Purpose**: Pick the right join type and physical strategy; avoid shuffles and skew
> **Confidence**: 0.95
> **Validated**: 2026-06-10

## Overview

Logical join types (`inner`, `left`, `anti`...) define semantics; the physical strategy
(broadcast hash join vs sort-merge join) defines cost. Spark's AQE (enabled by default in 3.x+)
auto-converts to broadcast when one side is small at runtime, but explicit hints are
deterministic and self-documenting.

## The Pattern

```python
from pyspark.sql import functions as F

# Small dimension (< ~100MB) joined to a large fact: broadcast it
result = fact.join(F.broadcast(dim), on="dim_id", how="left")

# Existence checks: semi/anti joins instead of join + filter/distinct
new_rows = incoming.join(existing, on="natural_key", how="left_anti")
```

## Quick Reference

| Need | Join | Note |
|------|------|------|
| Enrich keeping all left rows | `left` | Nulls on miss — handle them |
| Only matched rows | `inner` | Default |
| "Rows NOT present in other table" | `left_anti` | Replaces join+isNull filter |
| "Rows present in other table" (no columns from it) | `left_semi` | No duplication from right side |
| Both small sides | regular join | AQE decides strategy |

## Common Mistakes

### Wrong

```python
# Ambiguous columns after join — silent bugs downstream
df = a.join(b, a["id"] == b["id"])      # both id columns survive
# Skewed key joins: one huge task hangs the stage
```

### Correct

```python
df = a.join(b, on="id")                  # single id column, no ambiguity
# Skew: enable AQE skew handling (default on Databricks) or salt the hot key;
# verify with df.explain() — look for SortMergeJoin vs BroadcastHashJoin
```

## Related

- [lazy-evaluation-and-actions](lazy-evaluation-and-actions.md)
- [performance-essentials](../patterns/performance-essentials.md)
