(define-module gl.processing.util
  (use gauche.experimental.lamb)
  (use util.match)
  (use srfi-1)
  (export define* symbol-transform string-visible-size string-visible-size->index))
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

(define (string-visible-size str) ;; utf-8
  (let ((len (string-length str))
        (size (string-size str)))
    (let ((full-width-n (/. (- size len) 2))
          (half-width-n (/. (- (* 3 len) size) 2)))
      (floor->exact
       (+ half-width-n (* 2 full-width-n))))))

(define (string-visible-size->index s n)
  (define (loop i n)
    (cond [(>= 0 n) i]
          [(< #xff (char->integer (string-ref s i)))
           (loop (+ i 1) (- n 2))]
          [else (loop (+ i 1) (- n 1))]))
  (- (loop 0 n) 1))

