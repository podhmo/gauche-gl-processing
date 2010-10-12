(use gl.processing)
;; // Learning Processing
;; // Daniel Shiffman
;; // http://www.learningprocessing.com

;; // Example 8-2: Two Car objects

(define my-car1 #f)
(define my-car2 #f)

(define draw (draw$ (^ ()
                       (move! my-car1) (display my-car1)
                       (move! my-car2) (display my-car2))
                    :bg (cut background 255)))

(define main (setup$ (^ ()
                        (window 200 200 "" 100 100)
                        (set! my-car1 (make <car> :color '(255 0 0) :xpos 0 :ypos 100 :xspeed 2))
                        (set! my-car2 (make <car> :color '(0 0 255) :xpos 0 :ypos 10 :xspeed 1)))
                     :draw draw))

(define-class <car> ()
  [(color :init-keyword :color)ppp
   (xpos :init-keyword :xpos)
   (ypos :init-keyword :ypos)
   (xspeed :init-keyword :xspeed)])

(define-method display ((self <car>))
  (stroke 0)
  (apply fill (slot-ref self 'color))
  (rect-mode! 'center)
  (rect (slot-ref self 'xpos) (slot-ref self 'ypos) 20 10))

(define-method move! ((self <car>))
  (let* ((xpos (slot-ref self 'xpos))
         (xpos* (+ xpos (slot-ref self 'xspeed))))
    (slot-set! self 'xpos (if (> xpos* 200) 0 xpos*))))
