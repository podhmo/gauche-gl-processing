;; Example 8-2  Drawing a Complete Font
;;(use gauche.experimental.lamb)
(add-load-path "..")
(use graphics.imlib2)
(use gl.processing)


(define draw
  (draw-once$
   (lambda ()
     (fill 0.7 0.7 0)
     (rect 10 10 100 80)
     (fill 1.0 1.0 1.0)
     (text "THE QUICK BROWN FOX JUMPS" 20 40)
     (text "OVER A LAZY DOG" 20 60)
     (let* ((pixels (load-pixels))
            (img (gl-pixels->image pixels *width* *height*)))
       (save-image img "foo.png")))
   :bg (cut background 0 0 0)))

(define main
  (setup$ (lambda ()
            (window 300 100 "draw text" 100 100))
          :draw draw))
