(define points 
'#f32(10 10 0  10 0 0  0 0 0  0 10 0))
(gl-enable-client-state GL_VERTEX_ARRAY)
(gl-vertex-pointer 3 points)
(gl-draw-arrays GL_QUADS 0 4)
(gl-disable-client-state GL_VERTEX_ARRAY)
