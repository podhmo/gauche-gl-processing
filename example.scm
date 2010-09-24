(use gauche.uvector)
(add-load-path ".")
(use gl.processing)

                         
(define draw
  (draw$
   (lambda ()
     (fill 0 0 0)
     (rect 250 250 30 30)
     (fill 0.2 0.2 0.2)
     (ellipse 250 250 30 60)
     (line 10 10 100 10)
     (stroke-weight 3.0)
     (line 10 30 100 30) 
     (print "[ESC]:TO EXIT"))))
;   :draw-once? #t))

(define (keyboard key x y)
  (let ((ESC 27))
    (cond ((= key ESC) (begin
                         (print "key:: ESC")
                         (exit 0)))
          (else (print #`"key:: ,key")))))

(define main 
  (setup$ (cut window 500 500 "Gauche-GL" 100 100)
          :draw draw :keyboard keyboard))

(main '())