(use gl.processing)

(with-simple-draw (200 200)

  (blend-info)

  (background 0 0 0)
  (gl-enable GL_BLEND)
  (gl-blend-func GL_ONE GL_ONE)
  (translate 0 -50)
  (fill 255 0 0 123)
  (rect 50 100 50 50)
  (fill 0 255 0 123)
  (rect 100 100 50 50)
  (fill 0 0 255 123)
  (triangle 100 100 50 150 150 150)
  (triangle 100 200 50 150 150 150)
  
)

(main '())
    