
;; Write queries here (see $VIMRUNTIME/queries/ for examples).
;; Move cursor to a capture ("@foo") to highlight matches in the source buffer.
;; Completion for grammar nodes is available (:help compl-omni)

; (string_start) @string

(identifier) @id


((comment) @test_com
(#match? @test_com "\\s*['\"]{1,3}\\s*--\\s*sql")
  ; (#match? @test_com "^.[]\s*--sql")
  ) @test_comment

(
  (string_content) @test_content
  (#match? @test_content "['\"]{0,3}[\n\r\t]\s*--\s*sql" )
  (#set! injection.language "sql")
  ) @test_string

  ; (#eq? @test_content "^--sql")


(assignment
  left: (identifier) @sql_var
  right: (string
	(string_content) @str_cont
	) @sql_string
  (#match? @sql_string "\s*--\s*sql" )
  (#set! injection.language "sql")
  ) @t4

((string_content) @test_start
(#match? @test_start "^\n[ \n\r\t]*\s*--\s*sql")
; (#match? @test_start "from")
; (#match? @test_start "['\"]{1,3}\s*--\s*sql")
) @test2

(
 (string_content) @test_sql
(#match? @test_sql "^[ \\n\\r\\t ]*--\s*sql")
) @t3

(
 (string_content) @test_sql
(#match? @test_sql "^--\n")
; (#match? @test_sql "^[\n\r\t]*")
) @t3



(
  (string_content) @test_content
  ; (string_start) @test_start
  ; (#match? @test_content "^\\s*['\"]{1,3}\\s*--\\s*sql" )
  ; (#match? @test_content "^\"\"\"\s*--\s*sql" )
  ; (#match? @test_content "['\"]{1,3}" )
  (#match? @test_content "^[\n\r\t ]*\s*--\s*sql" )
  ; (#match? @test_content "^\s*--sql" )
  ; (#eq? @test_content "^--sql") @test_sql
  ) @test_string

(string
  (string_content) @test_content
  (#match? @test_content "^\s*--\s*sql")
) @test_string


;; Capture strings assigned to variables
(assignment
  left: (identifier) @sql_var
  right: (string) @sql_string) @sql

;; Capture strings passed as arguments to function calls
(call
  function: (attribute) @function_name
  arguments: (argument_list
    (string) @sql_string)) @sql

;; Capture string literals assigned to variables
(assignment
  left: (identifier) @sql_var
  right: (string) @sql_string)

;; Capture string literals passed as arguments to function calls
(call
  function: (attribute) @function_name
  arguments: (argument_list
    (string) @sql_string)) @sql

