# Documentation sources

This folder holds the Markdown sources for the future site
`https://2clipboard.endure.digital/`.

The files are plain Markdown, structured as one page per file, so any SSG
(Astro, Hugo, Eleventy, MkDocs, Docusaurus) or a simple static renderer
can consume them without transformation.

## Pages

| File | Website route | Purpose |
|---|---|---|
| `index.md` | `/` | Landing page: what it is, why it matters. |
| `install.md` | `/install` | Multi-distro installation. |
| `usage.md` | `/usage` | Actions, options, examples. |
| `templates.md` | `/templates` | Template gallery + `{{VAR}}` reference. |
| `integrations.md` | `/integrations` | sxhkd, i3, sway, Hyprland, XFCE4, scripts. |
| `recipes.md` | `/recipes` | Copy-paste recipes by workflow. |
| `faq.md` | `/faq` | Troubleshooting + common questions. |
| `roadmap.md` | `/roadmap` | Planned features, how to contribute. |

## Conventions

- One `# H1` per page — used as the on-page title.
- All code blocks use fenced markdown with a language tag (`bash`, `json`,
  `yaml`, `ini`) so they can be syntax-highlighted.
- Cross-page links are relative (e.g. `[usage](usage.md)`) — an SSG will
  rewrite them to the corresponding routes.
- Backlinks to ENDURE use the full `https://` URL so they survive any
  rendering pipeline.

## Building a site later

Any of these will work with zero transformation:

- **Hugo / Astro / Eleventy**: point `content/` at this folder.
- **MkDocs**: `mkdocs.yml` with `nav: [{Home: index.md}, {Install: install.md}, …]`.
- **Docusaurus**: copy the files into `docs/` and update `sidebars.js`.

When you're ready, we'll add the JSON-LD, OpenGraph, sitemap, and the
`ENDURE` footer automatically to every page with a small pre-build step.
