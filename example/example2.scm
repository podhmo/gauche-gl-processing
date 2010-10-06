;; animation , double-buffer
(add-load-path "..")
(use gl.processing)

(define *spin* 0.0)

(define draw
  (draw$ (lambda ()
           (translate 125 125)
           (rotate *spin* 0.0 0.0 1.0)
           (fill 255 255 255)
           (rect 0 0 50 50))))

(define (spin-display)
  (set! *spin* (modulo (+ *spin* 2.0) 360.0))
  (glut-post-redisplay))

(define (mouse button state x y)
  (cond
    ((= button GLUT_LEFT_BUTTON)
     (when (= state GLUT_DOWN) (glut-idle-func spin-display)))
    ((= button GLUT_MIDDLE_BUTTON)
     (when (= state GLUT_DOWN) (glut-idle-func #f))))
  )

(define main
  (setup$
   (lambda ()
     (window 250 250 "program-name" 100 100)
     (rect-mode! 'center))
   :draw draw
   :reshape (2d-elastic-reshape$ 250 250)
   :mouse mouse))

 (main '())