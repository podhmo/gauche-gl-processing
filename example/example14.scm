(use gl.processing)
(define draw (draw$
              (lambda ())))

(define (mouse button state x y)
  (let ((button*
         (cond [(eqv? button GLUT_LEFT_BUTTON)  "left"]
               [(eqv? button GLUT_MIDDLE_BUTTON)  "middle"]
               [(eqv? button GLUT_RIGHT_BUTTON)  "right"]))
        (state*
         (cond [(eqv? state GLUT_DOWN)  "down"]
               [(eqv? state GLUT_UP)  "up"])))
    (print button* ":" state*)))

(define (motion x y)
  (print x ", " y))

(define main
  (setup$ (lambda () (window 300 300 "mouse example" 100 100))
          :motion motion
          :mouse mouse))
;; (main '())
