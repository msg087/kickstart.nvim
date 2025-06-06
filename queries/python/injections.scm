; Inject SQL inside Python triple-quoted strings that start with `-- sql`

; (
;   (string
;     (string_content) @sql_content
;     (#match? @sql_content "^[\n\r\t ]*--\s*sql")
;     (#set! injection.language "sql")
;   ) @sql_string
; )

(
  (string
    (string_content) @injection.content
    (#match? @injection.content "^[\n\r\t ]*--[ ]*sql")
    (#set! injection.language "sql")
    (#set! injection.include_children true)
  )
)


