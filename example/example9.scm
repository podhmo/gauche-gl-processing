
;; Example 8-2  Drawing a Complete Font
;;(use gauche.experimental.lamb)
(add-load-path "..")
(extend gl.processing)
(use gauche.uvector)
(use graphics.imlib2)
(use gl.glc)

(define (glc-font-family font)
  (glc-get-fontc font GLC_FAMILY))


(define draw
  (draw-once$
   (lambda ()
     ;; #?=(glc-get-font-face myfont)
     (gl-color 1.0 0 0)
     (gl-raster-pos 50 130)
     (glc-render-string "あ、hello world!")
     #?=(glc-face-list myfont)
     #?=(glc-char-list myfont)
     #?=(glc-get-error)
   #?=(map glc-font-family #?=(glc-font-list))
   #?=(map glc-font-family #?=(glc-current-font-list))
   (print (glc-font-info myfont))
   (print (glc-info)))
   :bg (cut background 0 0 0)))


(define ctx #f)
(define myfont #f)(define myfont2 #f)
(define done '())
(define main
  (setup$ (lambda ()
            (window 1000 180 "glc Tutorial" 100 100)
            (set! ctx (glc-gen-context))
            (glc-context ctx)

            (glc-string-type GLC_UTF8_QSO)
            (glc-enable GLC_HINTING_QSO)

            (glc-append-catalog "~/.fonts/afm/")
            (glc-append-catalog "/usr/share/fonts/truetype/takao")
            (set! myfont (glc-gen-font-id))
            #?=(glc-new-font-from-family #?=myfont "Courier")
            (glc-append-font myfont)
            #?=(glc-new-font-from-family #?=myfont "Symbol")
            ;; #?=(glc-new-font-from-family #?=myfont "DejaVu Serif")
            (glc-font-face myfont "Bold")
            (glc-font myfont)
            (glc-render-style GLC_BITMAP)
            (glc-scale 100 100))
          :draw draw))

(main '())