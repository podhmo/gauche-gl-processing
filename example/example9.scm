;; save file
;; Example 8-2  Drawing a Complete Font
;;(use gauche.experimental.lamb)
(add-load-path "..")
(extend gl.processing)
(use gauche.uvector)
(use graphics.imlib2)


(define draw
  (draw-once$
   (lambda ()
     (rect 10 10 100 100)
     (gl-read-buffer GL_FRONT)
     (gl-pixel-store GL_UNPACK_ALIGNMENT 1)
     (let* ((pixels (load-pixels))
            (img (gl-pixels->image  pixels *width* *height*)))
       (save-image img "foo.png")))))

(define main
  (setup$ (lambda ()
            (window 300 300 "save-image" 100 100))
          :draw draw))

;;(main '())