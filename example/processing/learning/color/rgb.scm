(use gl.processing)

(define draw (draw-once$ (^ ()
                            (no-stroke!)
                            (gl-enable GL_BLEND)
                            (fill 255 0 0) ;; red
                            (ellipse 100 70 130 130)
                            (fill 0 255 0) ;; green
                            (ellipse 70 130 130 130)
                            (fill 0 0 255) ;; blue
                            (ellipse 130 130 130 130)

                            (gl-disable GL_BLEND)
                            (fill 0 0 0)
                            (text "R" 90 45)
                            (text "G" 35 165)
                            (text "B" 145 165)
                            )
                         :bg (cut background 0 0 0)
                         :save "rgb.png"))

(define main (setup$ (^ () 
                        (window 200 200 "rgb" 100 100)
;;                        (gl-enable GL_LINE_SMOOTH)
                        (gl-blend-func GL_ONE GL_ONE)
                        (font-mode! 'bitmap)
                        (load-font "Symbol" 30)
                        (gl-disable GL_DEPTH_TEST))
                     :draw draw))

(main '())