(define-module gl.processing.window
  (use gl.processing.core)
  (export-all))
(select-module gl.processing.window)

(define %default-passive-motion-function #f)
(define %default-motion-function #f)
(define %default-mouse-function #f)
(define (%default-draw-function)
  (fill 255 255 255)
  (stroke 0 0 0)
  (background 178 178 178))
(define %timer-function #f)

;; window 
(define (setup$ action 
                :key (reshape 2d-reshape) 
                (draw %default-draw-function) 
                (keyboard keyboard-esc-or-q-end) 
                (motion %default-motion-function)
                (timer %timer-function)
                (passive-motion %default-passive-motion-function)
                (mouse %default-mouse-function))
  (lambda (args)
    (glut-init args)
    (glut-init-display-mode (logior *buffer-mode* GLUT_RGBA))
    ;; (gl-clear-color 0.0 0.0 0.0 0.0)
    ;; (gl-shade-model GL_FLAT)

    (action)

    (glut-reshape-func reshape)
    (glut-display-func draw)
    (glut-keyboard-func keyboard)
    (when timer
      (timer (floor->exact (* 1000 (/. 1 *frame-rate*)))))
    (when mouse (glut-mouse-func mouse))
    (when motion (glut-motion-func motion))
    (when passive-motion (glut-passive-motion-func passive-motion))
    (glut-main-loop)
    0))

(define (size w h :optional mode) ;;mode is not implemented yet
  (set! *width* w)
  (set! *height* h)
  (glut-init-window-size w h))

(define (window w h title :optional (x #f) (y #f))
  (size w h)
  (when (and x y) (glut-init-window-position x y))
  (glut-create-window title))

(define (2d-reshape$ :key (style :processing)) ;; style :gl or :processing
  (lambda (w h)
    (gl-viewport 0 0 w h)
    (gl-matrix-mode GL_PROJECTION)
    (gl-load-identity)
    (cond ((equal? style :gl) (glu-ortho-2d 0 w 0 h))
          ((equal? style :math) 
           (let ((hw (/. w 2 )) (hh (/. h 2)))
             (glu-ortho-2d (- w) w (- h) h)))
          (else (glu-ortho-2d 0 w h 0)))
    (gl-matrix-mode GL_MODELVIEW)
    (gl-load-identity)))

(define 2d-reshape (2d-reshape$ :style :processing))
;
(define (2d-elastic-reshape$ w h :key (style :processing))
  (lambda (w* h*)
    (gl-viewport 0 0 w* h*)
    (gl-matrix-mode GL_PROJECTION)
    (gl-load-identity)
    (cond ((equal? style :gl) (glu-ortho-2d 0 w 0 h))
          ((equal? style :math) 
           (let ((hw (/. w 2 )) (hh (/. h 2)))
             (glu-ortho-2d (- w) w (- h) h)))
          (else (glu-ortho-2d 0 w h 0)))
    (gl-matrix-mode GL_MODELVIEW)
    (gl-load-identity)))

(define (keyboard-esc-or-q-end key x y)
  (let ((ESC 27) (q 113))
    (cond ((or (= key q) (= key ESC))
           (print "bye.")
           (exit 0))
          (else (print #`"key:: ,key")))))


;;;mouse
(define *mouse-button* #f) ;;left,right,middle
(define *mouse-pressed?* #f)
(define *mouse-clicked?* #f)
(define *mouse-x* -inf.0)
(define *mouse-y* -inf.0)
(define *pmouse-x* -inf.0)
(define *pmouse-y* -inf.0)
(define *button-alist* 
  `((,GLUT_LEFT_BUTTON . left)(,GLUT_RIGHT_BUTTON . right)(,GLUT_MIDDLE_BUTTON . middle)))


(define (processing-passive-motion-function x y)
  (set! *pmouse-x* *mouse-x*)
  (set! *pmouse-y* *mouse-y*)
  (set! *mouse-x* x)
  (set! *mouse-y* y))

(define (processing-motion-function x y)
  (set! *pmouse-x* *mouse-x*)
  (set! *pmouse-y* *mouse-y*)
  (set! *mouse-x* x)
  (set! *mouse-y* y))

(define (processing-mouse-function b s x y)
  (set! *mouse-button* (cdr (assoc b *button-alist*)))
  (set! *mouse-pressed?* (= GLUT_DOWN s)))


;; draw-function-fuctory
(define (draw-once$ action :key (bg %default-draw-function) (save #f))
  (set! *buffer-mode* GLUT_SINGLE)
  (lambda ()
    (bg)
    (gl-load-identity)
    (action)
    (when save (let1 image (gl-pixels->image (load-pixels) *width* *height*)
                 (save-image image save)))
    (gl-flush)))

(define (draw$ action :key (bg %default-draw-function) (save #f) (clean #t))
  (let ((done #f))
      (set! *buffer-mode* GLUT_DOUBLE)
      (set! %default-passive-motion-function
            processing-passive-motion-function)
      (set! %default-motion-function
            processing-motion-function)
      (set! %default-mouse-function
            processing-mouse-function)
      (set! %timer-function
            (timer$ (lambda (_) (redisplay))))
      (lambda ()
        (when (or (not done) clean)
          (set! done #t) (bg))
        (gl-load-identity)
        (action) 
        (when save (let1 image (gl-pixels->image (load-pixels) *width* *height*)
                     (save-image image save)))
        (glut-swap-buffers))))

