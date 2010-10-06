(define-module gl.processing.core
  (extend
   graphics.imlib2
   gl.processing.util
   gauche.experimental.lamb
   gauche.uvector
   gl
   gl.glut)
  (export-all))
(select-module gl.processing.core)

;; window size
(define *width* 0)
(define *height* 0)

(define *buffer-mode* GLUT_SINGLE)

(define *fill-color* #u8(255 255 255))

(define (fill . args)
  (set! *no-fill?* #f)
  (set! *fill-color* (apply u8vector args)))

(define *no-stroke?* #f)
(define *no-fill?* #f)
(define (no-stroke!) (set! *no-stroke?* #t))
(define (no-fill!) (set! *no-fill?* #t))

(define *stroke-color* '#f32(0 0 0))
(define (stroke . args)
  (set! *no-stroke?* #f)
  (set! *stroke-color* (apply f32vector args)))

(define stroke-weight gl-line-width)  

(define background 
  (case-lambda 
   [(r g b) (background r g b 0)]
   [(r g b a)
    (if (fixnum? r)
        (gl-clear-color (/. r 255) (/. g 255) (/. b 255) (/. a 255))
        (gl-clear-color r g b a))
    (gl-clear (logior GL_COLOR_BUFFER_BIT  GL_DEPTH_BUFFER_BIT))]))

(define (load-pixels)
  (gl-read-pixels 0 0 *width* *height* GL_RGBA GL_UNSIGNED_BYTE))

(define redisplay glut-post-redisplay)

(define gen-timer-id
  (let1 i 0
    (^ () (inc! i) i)))

(define (timer$ function)
  (^ (delay-time)
     (let1 id (gen-timer-id)
       (define (function* v)
         (function v)
         (glut-timer-func delay-time function* v))
       (glut-timer-func delay-time function* id))))

(define *frame-rate* 10)
(define (frame-rate! n) (set! *frame-rate* n))