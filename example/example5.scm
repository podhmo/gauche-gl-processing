;; draw pixels 
(add-load-path "../")
(use gl.processing)
(use gl.simple-image)
(use util.match)

(define *image-file* "flower.rgb")

(define (load)
  (unless (file-exists? *image-file*)
    (print "Couldn't find image file: " *image-file*)
    (exit 0))
  (match-let1 (width height depth image)
      (read-sgi-image *image-file*)
    (values width height image)))

(define main
  (receive (w h image) (load)
    (print (class-of image))
    (setup$
     (lambda ()
       (gl-pixel-store GL_UNPACK_ALIGNMENT 1)
       (window w h "example5" 100 100))
     :draw (draw-once$
            (cut gl-draw-pixels w h  GL_RGB GL_UNSIGNED_BYTE image)))))
