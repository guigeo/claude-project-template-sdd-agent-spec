# Deterministic Tiebreak in Aggregation

> **Purpose**: Get a reproducible "dominant category per group" when counts can tie
> **Validated**: 2026-06-24

## When to Use

- Computing "most frequent category per group" (mode) where ties are possible
- Output must be reproducible across runs — `max_by` alone won't guarantee that
- The tiebreak rule needs to be auditable and unit-testable without spinning up Spark

## Implementation

```sql
-- WRONG: max_by ties break non-deterministically across runs
SELECT group_key, MAX_BY(category, qty) AS dominant_category
FROM agg
GROUP BY group_key;

-- RIGHT: explicit tiebreak column in the ORDER BY
WITH ranked AS (
    SELECT group_key, category, COUNT(*) AS qty,
           ROW_NUMBER() OVER (
               PARTITION BY group_key
               ORDER BY COUNT(*) DESC, category ASC   -- tiebreak: lowest name wins
           ) AS rn
    FROM source
    GROUP BY group_key, category
)
SELECT group_key, category AS dominant_category
FROM ranked
WHERE rn = 1;
```

```python
# Mirror the EXACT same ordering in pure Python — fast unit test, no Spark needed
def dominant_category(counts: dict[str, int]) -> str | None:
    """Highest count wins; ties broken by name ascending (mirrors the SQL ORDER BY)."""
    if not counts:
        return None
    return min(counts, key=lambda k: (-counts[k], k))
```

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| Tiebreak column | Natural key, ascending | Pick something stable and always present (a name, an ID) — never rely on insertion order |
| Where the rule lives | Both: SQL (`ROW_NUMBER`) and a pure Python mirror | The pure function is what gets the pytest coverage, including the tie case explicitly |

## Example Usage

```python
import pytest

@pytest.mark.parametrize(
    ("counts", "expected"),
    [
        ({"A": 2, "B": 1}, "A"),
        ({"A": 1, "B": 2}, "B"),
        ({"B": 3, "A": 3}, "A"),  # tie -> lowest name
    ],
)
def test_dominant_category(counts: dict[str, int], expected: str) -> None:
    assert dominant_category(counts) == expected
```

## See Also

- [logica-pura-testavel](logica-pura-testavel.md)
- [performance-essentials](performance-essentials.md)
