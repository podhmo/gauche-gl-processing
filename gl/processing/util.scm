(define-module gl.processing.util
  (use gauche.experimental.lamb)
  (use util.match)
  (use srfi-1)
  (export define* symbol-transform))
(select-module gl.processing.util)

(define (symbol-transform fn sym)
  ((compose string->symbol fn symbol->string) sym))

(define-macro (define* args :key (main #f) (initialize #f))
  (match-let1 (name . args) args
    (let1 initialize? (gensym)
      `(define ,name
         (let1 ,initialize? #f
           (define (main ,@args)
             ,main)
           (define (initialize)
             (unless ,initialize?
               ,initialize
               (set! ,name main)))
           (lambda ,args
             (initialize)
             (main ,@(map (^x (if (list? x) (car x) x)) (remove keyword? args)))))))))
