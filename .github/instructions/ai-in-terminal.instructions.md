---
applyTo: "**"
description: Guidelines for using AI tools in terminal commands within the mobile development template system.
---

When working with terminal commands in this mobile development template system, follow these safety guidelines to prevent command hangs and ensure reliable operations.

Never use complex regex patterns with shell escaping that can cause terminal to hang at cmdand cmdor dquote prompts:
- Avoid: grep -r "pattern.*\(group1\|group2\)" dirs/ || echo "message"
- Avoid: cd dir && find . -name "*.ext" | xargs grep "pattern" | grep -E "regex" | wc -l

Never use cat with large content or heredoc that can cause terminal hangs:
- Avoid: cat > file.txt << 'EOF' with large content blocks
- Avoid: cat << EOF with complex multi-line conten
- Avoid: echo "large content..." > file.txt with special characters

Instead use VS Code file creation tools:
- Use create_file tool for creating new files with conten
- Use insert_edit_into_file for adding content to existing files
- Use replace_string_in_file for modifying existing conten
- Break large content into smaller chunks if needed

Instead use simple, incremental commands:
- Use: cd /workspace
- Use: grep -r "pattern1" docs/
- Use: grep -r "pattern2" docs/

Prefer VS Code integrated tools over shell commands when available:
- Use grep_search tool for text search across files
- Use file_search tool for finding files by patterns
- Use read_file tool for reading file conten
- Use replace_string_in_file for editing files

Safety rules for terminal operations:
- Execute one task per command - don't chain complex operations
- Test commands incrementally rather than all-in-one
- Break complex tasks into simple sequential steps
- Avoid complex regex patterns - use multiple simple patterns instead

If terminal gets stuck at cmdand cmdor dquote prompt:
- Press Ctrl+C to cancel the current command
- Type exit to exit the shell session if needed
- Restart with simple commands

For file editing operations:
- Always read files before editing to understand structure
- Include 3-5 lines of context before and after changes
- Use "// ...existing code..." comments instead of repeating existing code
- Use replace_string_in_file for specific text replacemen
- Use insert_edit_into_file for adding new conten
- Use create_file tool for creating new files instead of cat or echo
- Break large content into multiple smaller insert operations
- Avoid run_in_terminal for file editing unless specifically requested
- Never use cat with heredoc (<<EOF) or large content blocks in terminal

Content management strategies for large files:
- For files over 50 lines: break into logical sections and use multiple insert_edit_into_file calls
- For configuration files: update specific sections rather than replacing entire conten
- For documentation: add sections incrementally rather than all at once
- For code files: implement features one function/method at a time
- Always prefer VS Code tools over terminal commands for file operations

Examples of safe file operations:
- Good: create_file tool with complete conten
- Good: insert_edit_into_file with focused additions
- Good: replace_string_in_file with specific text replacemen
- Bad: cat > file.txt << 'EOF' with large heredoc
- Bad: echo "complex content with quotes" > file.tx
- Bad: printf "multi-line content" > file.tx

This mobile template system uses mise for tool management and focuses on Flutter and React Native development with these key directories:
- templates/ for development templates
- playground/ for testing and experimentation (not test/)
- scripts/ for production automation
- docs/ for documentation
