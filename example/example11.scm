;;; redefine draw function then update display automatically

(extend gl.processing)
(use gl.processing.interactive)

(setup-with-other-thread
 (lambda ()
   (window 200 200 "animation" 0 100)
   (rect-mode! 'center)
   (update-timer 100)))

;;redrawの中を書き換えてgoshに送ると、変更が反映される。
(redraw 
  (background 0.4 0.4 0)
  (rect 100 120 30 30))

