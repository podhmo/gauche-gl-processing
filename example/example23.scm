(use gl.processing)

(define draw 
  (draw-once$
   (^ ()
      (no-fill!)
      (polygon 3 50 75 50)
      (polygon 4 170 75 50)
      
      (fill 255 204 255)
      (stroke 128 0 128)
      (polygon 5 50 180 50)
      
      (no-fill!)
      (stroke 30)
      (polygon 6 170 180 50))
   :bg (cut background 255)))


(define main (setup$ (^ () (window 300 300 ""))
                     :draw draw))

(define (polygon n cx cy r)
  (let1 angle (/. 360 n)
    (with-fill 
     (gl-begin* GL_POLYGON
                (dotimes (i n)
                  (gl-vertex (+ cx (* r (cos (radians (* angle i)))))
                             (+ cy (* r (sin (radians (* angle i)))))))))
    (with-stroke
     (gl-begin* GL_LINE_LOOP
                (dotimes (i n)
                  (gl-vertex (+ cx (* r (cos (radians (* angle i)))))
                             (+ cy (* r (sin (radians (* angle i)))))))))))
(main '())