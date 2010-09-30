(define-module gl.processing.window
  (use gl.processing.core)
  (export-all))
(select-module gl.processing.window)

;;;window 
(define (setup$ action 
                :key (reshape 2d-reshape) 
                (draw default-draw-function) 
                (keyboard default-keyboard-function) 
                (mouse #f))
  (^ (args)
    (glut-init args)
    (glut-init-display-mode (logior *buffer-mode* GLUT_RGB))
    (gl-clear-color 0.0 0.0 0.0 0.0)
    (gl-shade-model GL_FLAT)
    (action)
    (glut-reshape-func reshape)
    (glut-display-func draw)
    (glut-keyboard-func keyboard)
    (when mouse (glut-mouse-func mouse))
    (glut-main-loop)
    0))

(define (size w h :optional mode) ;;mode is not implemented yet
  (glut-init-window-size w h))

(define (window w h title :optional (x #f) (y #f))
  (size w h)
  (when (and x y) (glut-init-window-position x y))
  (glut-create-window title))

(define (2d-reshape w h)
  (gl-viewport 0 0 w h)
  (gl-matrix-mode GL_PROJECTION)
  (gl-load-identity)
  (glu-ortho-2d 0 w h 0)
  (gl-matrix-mode GL_MODELVIEW)
  (gl-load-identity))

(define (2d-elastic-reshape$ w h)
  (lambda (w* h*)
    (gl-viewport 0 0 w* h*)
    (gl-matrix-mode GL_PROJECTION)
    (gl-load-identity)
    (glu-ortho-2d 0 w h 0)
    (gl-matrix-mode GL_MODELVIEW)
    (gl-load-identity)))

(define (keyboard-esc-or-q-end key x y)
  (let ((ESC 27))
    (cond ((= key ESC) (begin
                         (print "key:: ESC")
                         (exit 0)))
          (else (print #`"key:: ,key")))))
(define default-keyboard-function keyboard-esc-or-q-end)

;; draw-function-fuctory
(define (default-draw-function)
  (background 0.7 0.7 0.7))

(define (draw-once$ action :key (bg default-draw-function))
    (set! *buffer-mode* GLUT_SINGLE)
    (lambda ()
        (bg)
        (action)
        (gl-flush)))

(define (draw$ action :key (bg default-draw-function))
  (set! *buffer-mode* GLUT_DOUBLE)
  (lambda ()
    (bg)
    (gl-push-matrix)
    (action) 
    (gl-pop-matrix)
    (glut-swap-buffers)))
