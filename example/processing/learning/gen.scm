#!/usr/bin/env gosh
(use file.util)
(use util.match)

(define (generate-project path)
  (make-directory* path)
  (copy-file "color/Rakefile" (build-path path "Rakefile"))
  (copy-file "color/template.scm" (build-path path "template.scm")))

(define (main args)
  (match-let1 (_ . files) args
      (dolist (file files)
        (unless (and (file-exists? file) (file-is-directory? file))
                 (generate-project file)))
      0))
