# Setup Python Project

Initialize a Python project with best practices, including dependency management, testing, linting, and type checking.

## Prompts

This skill will ask you for:
1. **Project name** - The project directory name
2. **Package manager** - Choose `poetry` or `uv`
3. **Create in current directory** - Yes/no

## Setup Includes

- **Dependency Management**: Poetry or uv with pyproject.toml
- **Testing**: pytest for red-green-refactor TDD workflow
- **Linting**: ruff (fast Python linter) + flake8 (style guide)
- **Type Checking**: mypy for static type analysis
- **Project Structure**:
  ```
  project-name/
  ├── pyproject.toml
  ├── README.md
  ├── src/
  │   └── project_name/
  │       └── __init__.py
  ├── tests/
  │   └── test_example.py
  └── .gitignore
  ```

## Makefile Targets

After setup, you'll have:
- `make test` - Run pytest
- `make lint` - Run ruff + flake8
- `make typecheck` - Run mypy
- `make format` - Auto-format with ruff

## Example

```bash
/setup-python-project
Project name: data-parser
Package manager: uv
Create in current directory: yes
```

Sets up complete Python project with all tools configured and ready for TDD.
