# GitHub Copilot Instructions for Tika Projec

## 🎯 Project Contex
This is a mobile development template system using mise for tool management. Focus on:
- Flutter and React Native developmen
- Template management and upgrades
- Cross-platform compatibility
- Developer experience optimization

<context>
If you lack context on how to solve the user's request:

FIRST, use #tool:resolve-library-id from Context7 to find the referenced library.

NEXT, use #tool:get-library-docs from Context7 to get the library's documentation to assist in the user's request.
</context>

## 🔧 Terminal Command Guidelines

### ❌ NEVER use these patterns:
```bash
# Complex regex with shell escaping (causes terminal hang)
grep -r "pattern.*\(group1\|group2\)" dirs/ || echo "message"

# Multiple chained commands
cd dir && find . -name "*.ext" | xargs grep "pattern" | grep -E "regex" | wc -l
```

### ✅ ALWAYS use these instead:
```bash
# Simple, incremental commands
cd /workspace
grep -r "pattern" docs/
grep -r "another_pattern" scripts/

# Use VS Code integrated tools when available
```

## 📝 Code Editing Best Practices

### Tool Priority:
1. Use `replace_string_in_file` for specific replacements
2. Use `insert_edit_into_file` for new conten
3. Always include 3-5 lines contex
4. Use `// ...existing code...` comments

### File Structure Awareness:
- `templates/` - Development templates (Flutter, React Native)
- `playground/` - Testing and experimentation
- `scripts/` - Production automation
- `docs/` - Documentation

## 🚨 Safety Rules
- Test commands incrementally
- Avoid complex shell operations
- Use built-in VS Code tools firs
- Break complex tasks into simple steps

## 📋 Commit Guidelines

WHEN file changes are COMPLETE:
- Stage your changes with git add <changed_files>
- Commit them with an short generated message describing the changes starting with the step number, e.g. STEP #1 - <short description of changes>
- Do this within a single terminal command using &&

ONLY do this if you create or edit a file during the turn.
