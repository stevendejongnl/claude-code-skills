# Create Mosaic Component

Scaffold a new Lit web component with atomic design structure in the Mosaic components library.

## Prompts

This skill will ask you for:
1. **Component name** - PascalCase identifier (e.g., `ButtonGroup`)
2. **Description** - Brief description of what the component does
3. **Location** - Where to create it (atoms, molecules, organisms, templates)

## Output

Creates a complete component with:
- TypeScript class with Lit decorators
- CSS scoped styles
- Stories file for Storybook
- README documentation
- Proper directory structure

## Example

```bash
/create-mosaic-component
Component name: ButtonGroup
Description: A grouped button component with toggle functionality
Location: molecules
```

Creates:
```
components/molecules/button-group/
├── button-group.ts
├── button-group.stories.ts
├── button-group.css
├── README.md
└── index.ts
```
