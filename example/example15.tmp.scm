;; texture with gl-tex-coord
(use gl.processing)

(define (load-image-file file)
  (let1 img (load-image file)
    (values (image-width img) 
            (image-height img)
            (image->gl img :alpha #t))))


(define (file->texture file)
  (receive (w h img) (load-image-file file)
    (image->texture img w h :alpha #t)))

(define main
  (let ((texture1 #f) (texture2 #f))
    (let1 draw  (draw-once$
                 (lambda ()
                   (with-texture
                    (translate 50 50)
                    (draw-shape texture1 300 300)
                    (translate 0 320)
                    (draw-shape texture2 80 80))))
      (setup$ (lambda ()
                (window 500 500 "texture" 100 100)
                (set! texture1 (file->texture "lisp-redpill.jpg"))
                (set! texture2 (file->texture "lisp-glossy.jpg")))
            :draw draw))))

(main '())

