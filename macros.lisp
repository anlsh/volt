(in-package :volt)

(defmacro sethash ((key val) table)
  `(setf (gethash ,key ,table) ,val))

(defun put-if-absent (key val table)
  (unless (second (multiple-value-list (gethash key table)))
    (setf (gethash key table) val)))
