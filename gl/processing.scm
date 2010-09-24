(define-module gl.processing
  (extend gl gl.glut 
          gl.processing.window gl.processing.2d)
  (export-all))
(select-module gl.processing)

(define fill gl-color)
(define stroke-weight gl-line-width)

(define background 
  (case-lambda
   [(r g b)
    (gl-clear-color r g b 0.0)
    (gl-clear GL_COLOR_BUFFER_BIT)]
   [(r g b a) (gl-clear-color r g b a)
    (gl-clear GL_COLOR_BUFFER_BIT)]))

(define *draw-once?* #f)
(define (draw$ action :key (draw-once? #f) (bg (cut background 0.5 0.5 0.5)))
  (set! *draw-once?* #f)
  (lambda ()
    (unless *draw-once?*
      (set! *draw-once?* #t)
      (bg)
      (action)
      (gl-flush))))


