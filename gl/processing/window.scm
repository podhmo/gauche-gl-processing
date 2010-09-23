(define-module gl.processing.window
  (use gauche.experimental.lamb)
  (use gl)
  (use gl.glut)
  (export-all))
(select-module gl.processing.window)

;;;window 

(define (setup$ action :key (reshape 2d-reshape) (draw #f) (keyboard #f))
  (^ (args)
    (glut-init args)
    (glut-init-display-mode (logior GLUT_SINGLE GLUT_RGB))
    (gl-clear-color 0.0 0.0 0.0 0.0)
    (gl-shade-model GL_FLAT)
    (action)
    (glut-reshape-func reshape)
    (glut-display-func draw)
    (glut-keyboard-func keyboard)
    (glut-main-loop)
    0))

(define (size w h :optional mode) ;;mode is not implemented yet
  (glut-init-window-size w h))

(define (window w h title :optional (x #f) (y #f))
  (size w h)
  (when (and x y) (glut-init-window-position x y))
  (glut-create-window title)
  (gl-matrix-mode GL_PROJECTION)
  (gl-load-identity)
  (glu-ortho-2d 0 w 0 h))


(define (2d-reshape w h)
  (gl-viewport 0 0 w h)
  (gl-matrix-mode GL_PROJECTION)
  (gl-load-identity)
  (glu-ortho-2d 0 w 0 h)
  (gl-matrix-mode GL_MODELVIEW)
  (gl-load-identity))
