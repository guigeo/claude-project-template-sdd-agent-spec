# Notebook vs File Libraries (avoiding sys.modules collisions)

> **Purpose**: Add auxiliary source files to a declarative pipeline without name collisions
> **MCP Validated**: 2026-06-24

## When to Use

- A pipeline has multiple source files (notebooks) that each define their own
  helper code, and several of them follow the same naming convention
- Two pipeline source files would otherwise define objects with the same name
  when attached as plain file libraries
- Adding a new set of datasets to an existing pipeline (Free Edition / any
  workspace limited to one active pipeline per type) without touching the
  files of datasets already shipped

## Implementation

```yaml
# resources/my_pipeline.pipeline.yml
resources:
  pipelines:
    my_pipeline:
      libraries:
        - notebook: { path: ../src/gold/pipeline_a.py }
        - notebook: { path: ../src/gold/pipeline_b.py }   # new dataset, same pipeline
        # - file: { path: ../src/gold/pipeline_b.py }     # AVOID: file libraries can
        #                                                   collide in sys.modules when
        #                                                   another source file in the
        #                                                   same pipeline defines an
        #                                                   object with the same name
```

`notebook:` libraries get a unique synthetic module name from the runtime, so
two notebooks defining a function or variable with the same name don't
shadow each other. `file:` libraries are imported like regular Python modules
and can collide when the pipeline grows past one file.

## Configuration

| Setting | Default | Description |
|---------|---------|--------------|
| Library type for new pipeline source files | `notebook:` | Safer default once a pipeline has more than one source file |
| When `file:` is fine | Single-file pipeline, or files guaranteed to have disjoint top-level names | Verify before relying on it — the collision is silent until two names actually clash |

## Example Usage

```text
Adding a 3rd dataset group to a pipeline that already has 2 notebook libraries:
1. Create the new notebook file (own module-level names, own @dp.materialized_view defs)
2. Add it as a `notebook:` library entry alongside the existing ones
3. The declarative engine resolves the dataset DAG across all attached libraries automatically
```

## See Also

- [free-edition-constraints](../concepts/free-edition-constraints.md)
- [logica-pura-testavel](../../pyspark/patterns/logica-pura-testavel.md)
- [autoria-streaming-table](autoria-streaming-table.md)
