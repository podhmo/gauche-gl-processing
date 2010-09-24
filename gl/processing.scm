(define-module gl.processing
  (extend gl gl.glut 
          gl.processing.window gl.processing.2d gl.processing.transform)
  (export-all))
(select-module gl.processing)

(define stroke-weight gl-line-width)

(define background 
  (case-lambda
   [(r g b)
    (gl-clear-color r g b 0.0)
    (gl-clear GL_COLOR_BUFFER_BIT)]
   [(r g b a) (gl-clear-color r g b a)
    (gl-clear GL_COLOR_BUFFER_BIT)]))


;; draw-function-fuctory
;; *buffer-mode* is internal variable(defined in window.scm)
(define (draw-once$ action :key (bg (cut background 0.7 0.7 0.7)))
    (set! *buffer-mode* GLUT_SINGLE)
    (lambda ()
        (bg)
        (action)
        (gl-flush)))

(define (draw$ action :key (draw-once? #f) (bg (cut background 0.7 0.7 0.7)))
  (set! *buffer-mode* GLUT_DOUBLE)
  (lambda ()
    (bg)
    (gl-push-matrix)
    (action) 
    (gl-pop-matrix)
    (glut-swap-buffers)))


