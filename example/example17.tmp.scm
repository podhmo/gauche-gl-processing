(extend gl.processing)
(use gl.processing.interactive)


;; (define main 
;;   (setup$ (lambda ()
;;             (window 200 200 "foo" 100 100)
;;             (font-mode! 'texture)
;;             ;; (font-mode! 'bitmap)
;;             (load-font "Utopia" 40))
;;           :draw draw))
;; (main '())

(setup-with-other-thread
 (lambda ()
   (window 200 200 "animation" 100 100)
   (font-mode! 'texture)
   (update-timer 100)
   (load-font "Utopia" 40)))

;;redrawの中を書き換えてgoshに送ると、変更が反映される。
(redraw 
 (gl-matrix-mode GL_TEXTURE)
 (gl-load-identity)
 (gl-scale 1 1 1)
;; (gl-translate 0 0.4 0)
 (gl-matrix-mode GL_MODELVIEW)
 (with-texture
  (text "VAV" 10 100)
  (fill 255 0 0)
  (rect 100 20 10 10)
  ;;                  (translate 100 0)
  (text "abc" 100 20)))
