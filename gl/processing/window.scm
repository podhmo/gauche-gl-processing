(define-module gl.processing.window
  (use gauche.experimental.lamb)
  (use gl)
  (use gl.glut)
  (export-all))
(select-module gl.processing.window)

;;;window 
(define *buffer-mode* GLUT_SINGLE)
(define (setup$ action 
                :key (reshape 2d-reshape) 
                (draw #f) 
                (keyboard keyboard-esc-end) 
                (mouse #f))
  (^ (args)
    (glut-init args)
    (glut-init-display-mode (logior *buffer-mode* GLUT_RGB))
    (gl-clear-color 0.0 0.0 0.0 0.0)
    (gl-shade-model GL_FLAT)
    (action)
    (glut-reshape-func reshape)
    (glut-display-func draw)
    (when keyboard (glut-keyboard-func keyboard))
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


(define (keyboard-esc-end key x y)
  (let ((ESC 27))
    (cond ((= key ESC) (begin
                         (print "key:: ESC")
                         (exit 0)))
          (else (print #`"key:: ,key")))))
