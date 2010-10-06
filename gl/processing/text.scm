(define-module gl.processing.text
  (use gl.processing.core)
  (use gl.glc)
  (export-all))
(select-module gl.processing.text)



(define *font* #f)
(define *font-scale* 32)
(define (text-font! font) (set! *font* font))
(define (font-scale! scale) (set! *font-scale* scale))
(define (text content x y)
  (gl-color *fill-color*)
  (gl-raster-pos x y)
  (glc-render-string content))

(define *glc-context* #f)
(define *font-list* '())

(define-class <font> ()
  [(id :init-keyword :id)
   (family :init-keyword :family)])

(define* (load-font family)
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
           (glc-scale *font-scale* *font-scale*)
           (glc-append-font id)
           (rlet1 font (make <font> :id id :family (glc-get-fontc id GLC_FAMILY))
             (push! *font-list* font)))
          (else (errorf "invalid font:~a is not found" file)))))
