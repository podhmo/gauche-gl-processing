(define-module gl.processing.text
  (use util.match)
  (use gl.processing.core)
  (use gl.glc)
  (export-all))
(select-module gl.processing.text)



(define *font* #f)
(define *font-scale* 32)
(define (text-font! font) (set! *font* font))
(define (font-scale! scale) (set! *font-scale* scale))

(define text
  (case-lambda
   [(content x y) (%text3 content x y)]
   [(content x y w h) (%text5 content x y w h)]))

(define (%text3 content x y)
  (gl-color *fill-color*)
  (gl-raster-pos x y)
  (glc-render-string content))

(define (%text5 content x y width height)
  (define (%add-offset width)
    (+ width (quotient *font-scale* 2)))
  (define (divide-string width letter-size)
    (define (loop xs acc tmp i)
      (match xs
        [() (reverse (cons (reverse tmp) acc))]
        [(x . xs*)
         (let1 len (* letter-size (string-length x))
           (cond [(> len width)
                  (let1 n (quotient width letter-size)
                    (let ((x* (substring x n -1))
                          (acc* (cons (reverse (cons (substring x 0 n) tmp)) acc)))
                      (if (string=? x* "")
                          (loop xs* acc* '() 0)
                          (loop (cons x* xs*) acc* '() 0))))]
                 [(> (+ len i) width)
                  (loop xs* (cons (reverse tmp) acc) (list x) (+ letter-size len))]
                 [else
                  (loop xs* acc (cons x tmp) (+ i letter-size len))]))]))
    (match-let1 (x . xs) (string-split content " ")
      (let1 len (* letter-size (string-length x))
        (cond [(> len width)
               (let1 n (quotient width letter-size)
                 (let ((xs* (cons (substring x n -1) xs))
                       (x* (substring x 0 n)))
                   (loop xs* `((,x*)) '() 0)))]
              [else
               (loop xs '() `(,x) len)]))))

  (define (draw-loop x y dy strs)
    (match strs
      [() (undefined)]
      ([e . es] 
       (gl-raster-pos x y)
       (glc-render-string (string-join e " "))
       (draw-loop x (+ dy y) dy es))))
  (gl-color *fill-color*)
  (let1 strs (divide-string (%add-offset (* width 2))*font-scale*)
    (draw-loop x (+ (quotient *font-scale* 2) y) (quotient height (length strs))  strs)))

(define *glc-context* #f)
(define *font-list* '())

(define-class <font> ()
  [(id :init-keyword :id)
   (family :init-keyword :family)])

(define* (load-font family :optional (s #f))
  :initialize
  (begin
    (set! *glc-context* (glc-gen-context))
    (glc-context *glc-context*)
    (glc-string-type GLC_UTF8_QSO)
    (glc-enable GLC_HINTING_QSO))
  :main
  (let1 id (glc-gen-font-id)
    (cond ((glc-new-font-from-family id family)
           (glc-font id)
           (when s (set! *font-scale* s))
           (glc-scale *font-scale* *font-scale*)
           (glc-append-font id)
           (rlet1 font (make <font> :id id :family (glc-get-fontc id GLC_FAMILY))
             (push! *font-list* font)))
          (else (errorf "invalid font:~a is not found" file)))))
