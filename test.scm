(add-load-path ".")
(use gl.processing.util)
(use gauche.test)

(test-start "test...")
(test-module 'gl.processing.util)

;;(test-section "gl.processing.util")
(test-section "string-visible-size")
(test* "abc" 3 (string-visible-size "abc"))
(test* "abcあ" 5 (string-visible-size "abcあ"))
(test* "abcあいう" 9 (string-visible-size "abcあいう"))

(test-section "string-visible-size->index")
(test* "abc 2" 2 (string-visible-size->index "abc" 3))
(test* "aあ 3" 1 (string-visible-size->index "aあ" 3))
(test* "あabc 3" "あ" (substring "あabc" 0 (string-visible-size->index "あabc" 3)))
(test* "あabc 4" "あa" (substring "あabc" 0 (string-visible-size->index "あabc" 4)))

(test-end)
