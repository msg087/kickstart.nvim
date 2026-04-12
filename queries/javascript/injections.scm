; (
;   (string
;     (string_content) @injection.content
;     (#match? @injection.content "^[\n\r\t ]*\/\*[ ]css\*\/")
;     (#set! injection.language "css")
;     (#set! injection.include_children true)
;   )
; )

; (
;   (template_string
;     (string_fragment) @injection.content
;     (#match? @injection.content "^\\s*/\\*css\\*/")
;     (#set! injection.language "css")
;   )
; )

; (
;   (assignment_expression
;     right: (template_string
;       (string_fragment) @injection.content
;       (#match? @injection.content "^/\\*css\\*/")
;     )
;   )
;   (#set! injection.language "css")
;   (#set! injection.include_children true)
; )

; (
;   (template_string) @injection.content
;   (#match? @injection.content "^\\s*`/\\*css\\*/")
;   (#set! injection.language "css")
; )

; (
;  (
;   (string_fragment) @injection.content
;   (#match? @injection.content "/\\*css\\*/")
;  )
;   (#set! injection.language "css")
;   (#set! injection.include_children true)

; )

(
  (template_string) @injection.content
  (#match? @injection.content "/\\*css\\*/")
  (#set! injection.language "css")
  (#set! injection.include_children true)
)


; (
;  (template_string
;   (string_fragment) @injection.content
;   (#match? @injection.content "/\\*css\\*/")
;   (#set! injection.language "css")
;   (#set! injection.include_children true)
;   )
; )

(
  (template_string) @injection.content
  (#set! injection.language "css")
)

(
  (string_fragment) @injection.content
  (#set! injection.language "css")
)

; Match tagged template literals like styled.div` ... `
(call_expression
  function: [
    (identifier) @_name
    (member_expression
      object: (identifier) @_name)
  ]
  arguments: (template_string (string_fragment) @injection.content)
  (#match? @_name "styled")
  (#set! injection.language "css")
  (#set! injection.combined)
)


; Match any template string preceded by a /* CSS */ comment
((comment) @_comment
  . (template_string (string_fragment) @injection.content)
  (#match? @_comment "CSS")
  (#set! injection.language "css")
  )

