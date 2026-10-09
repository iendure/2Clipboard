<p align="center">
  <img src="../assets/ENDURE__logo__dark_Built_to_last.svg" alt="ENDURE — Built to last" width="240">
</p>

# Examples

Ready-to-use assets that ship with 2Clipboard.

## Templates

Copy any of them to your local templates directory and use with
`--profile NAME`:

    mkdir -p ~/.config/2Clipboard/templates
    cp templates/*.tpl ~/.config/2Clipboard/templates/

    # Then, e.g.:
    2Clipboard header --profile llm --title "Session" --tags "ai,research"

| Template | Purpose |
|---|---|
| `templates/llm.tpl` | LLM chat / prompt sessions. |
| `templates/zettel.tpl` | Zettelkasten note header. |
| `templates/work.tpl` | Daily work log. |
| `templates/bug.tpl` | Bug report with command output. |
| `templates/minimal.tpl` | One-line header + tags. |

Full variable reference in the main [README](../README.md#template-variables).
