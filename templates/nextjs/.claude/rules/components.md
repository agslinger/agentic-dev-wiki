---
paths:
  - "components/**/*.tsx"
  - "components/**/*.ts"
---

# Component Rules

- Use shadcn/ui components before building custom ones.
- Use Lucide React for all icons — do not mix icon libraries.
- Use Tailwind CSS for styling — do not add CSS modules or styled-components.
- Keep components focused on a single responsibility.
- Colocate component-specific types in the same file.
- Make UI changes in small vertical slices and verify the smallest affected behavior before broadening the change.
- Prefer one passing component or route improvement over a large unfinished UI rewrite.
- Optimize for the simplest component path that proves the UI pattern works before scaling it across the tree.
- For new UI patterns, prove one simple component path first before applying the same pattern to the rest of the component tree.
