; ============================================================================
; Evidence.dev Treesitter Injections for Markdown
; Comprehensive Svelte injections for Evidence components, control blocks, expressions, and partials
; SQL code blocks with interpolation support
; Compatible with render-markdown.nvim
; ============================================================================

; ----------------------------------------------------------
; 0. Standard fenced code block injections
; ----------------------------------------------------------
(fenced_code_block
  (info_string (language) @injection.language)
  (code_fence_content) @injection.content)

; ----------------------------------------------------------
; 1. SQL code blocks
; ----------------------------------------------------------
(fenced_code_block
  (info_string (language) @_lang)
  (code_fence_content) @injection.content
  (#eq? @_lang "sql")
  (#set! injection.language "sql"))

; ----------------------------------------------------------
; 2. HTML blocks (for Evidence components)
;    Inject JavaScript for components and expressions
; ----------------------------------------------------------
((html_block) @injection.content
  (#set! injection.language "javascript")
  (#set! injection.combined)
  (#set! injection.include-children))

; ----------------------------------------------------------
; 3. Evidence partials in paragraphs
; ----------------------------------------------------------
((paragraph) @injection.content
  (#lua-match? @injection.content "\\{@partial")
  (#set! injection.language "svelte"))

; ----------------------------------------------------------
; 4. Svelte control blocks in paragraphs
; ----------------------------------------------------------
((paragraph) @injection.content
  (#lua-match? @injection.content "\\{#(each|if|await)")
  (#set! injection.language "svelte"))

((paragraph) @injection.content
  (#lua-match? @injection.content "\\{/(each|if|await)")
  (#set! injection.language "svelte"))

; ----------------------------------------------------------
; 5. Svelte expressions in paragraphs
; ----------------------------------------------------------
((paragraph) @injection.content
  (#lua-match? @injection.content "\\{[^#/][^}]*\\}")
  (#set! injection.language "svelte"))

; ----------------------------------------------------------
; 6. Evidence components in indented code blocks
; ----------------------------------------------------------
((indented_code_block) @injection.content
  (#lua-match? @injection.content "<")
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))
