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
; 2. All HTML blocks (Evidence components)
; ----------------------------------------------------------
((html_block) @injection.content
  (#set! injection.language "javascript")
  (#set! injection.combined)
  (#set! injection.include-children))

; ----------------------------------------------------------
; 3. All indented code blocks (Evidence content)
; ----------------------------------------------------------
((indented_code_block) @injection.content
  (#set! injection.language "javascript")
  (#set! injection.combined)
  (#set! injection.include-children))

; ----------------------------------------------------------
; 4. Evidence partials in paragraphs
; ----------------------------------------------------------
((paragraph) @injection.content
  (#lua-match? @injection.content "\\{@partial")
  (#set! injection.language "javascript"))

; ----------------------------------------------------------
; 5. Svelte control blocks in paragraphs
; ----------------------------------------------------------
((paragraph) @injection.content
  (#lua-match? @injection.content "\\{#(each|if|await)")
  (#set! injection.language "javascript"))

((paragraph) @injection.content
  (#lua-match? @injection.content "\\{/(each|if|await)")
  (#set! injection.language "javascript"))

; ----------------------------------------------------------
; 6. Svelte expressions in paragraphs
; ----------------------------------------------------------
((paragraph) @injection.content
  (#lua-match? @injection.content "\\{[^#/][^}]*\\}")
  (#set! injection.language "javascript"))
