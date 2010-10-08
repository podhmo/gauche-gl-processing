(use gl.processing)

(with-simple-draw (200 200)
  (translate 0 -50)
  (fill 255 0 0)
  (rect 50 100 50 50)
  (fill 0 255 0)
  (rect 100 100 50 50)
  (fill 0 0 255)
  (triangle 100 100 50 150 150 150)
  (triangle 100 200 50 150 150 150)
)

(main '())
    