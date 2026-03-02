# UI Modules

Optional domain-oriented UI modules live here.

## Rule
- Prefer small, composable modules
- Keep business logic in a thin layer (hooks/services), not in pages
- Avoid cross-module imports unless via a shared abstraction

## Suggested structure (when needed)
- `src/modules/<domain>/components`
- `src/modules/<domain>/hooks`
- `src/modules/<domain>/services`
- `src/modules/<domain>/types`