(in-package :volt)

(defun transpose (list-of-lists)
  (apply #'mapcar #'list list-of-lists))
