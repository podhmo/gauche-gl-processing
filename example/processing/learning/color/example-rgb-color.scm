(use gl.processing)

(with-simple-draw (100 100)
  (background 255)
  (no-stroke!)

  ;; Bright red  
  (fill 255 0 0)
  (ellipse 20 20 16 16)

  ;; Dark red
  (fill 127 0 0)
  (ellipse 40 20 16 16)

  ;; Pink (pale red)
  (fill 255 200 200)
  (ellipse 60 20 16 16))

;;(main '())
