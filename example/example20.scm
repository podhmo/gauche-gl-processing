(extend gl.processing)

(define draw (draw$ (^ () (gl-draw-pixels 200 200 GL_RGB GL_UNSIGNED_BYTE pixels))
                    :save "foo.png"))

(define pixels
  (pixels-generator 200 200 (^ (i j)
                               (values 0 i j))
                    :type :rgb))

(define main (setup$ (^ ()
                        (window 200 200 "f00" 100 100)
                        (gl-pixel-store GL_UNPACK_ALIGNMENT 1))
                     :draw draw))

(main '())
