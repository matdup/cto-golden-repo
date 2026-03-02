# Rust Service (Optional)

Use Rust only when it is justified:
- critical security boundary
- performance hotspots where GC/latency matters
- isolated components with strict correctness constraints

## Expected endpoints
- `GET /health`
- `GET /ready`

## Status
This is an optional service scaffold. Wire it only when needed.