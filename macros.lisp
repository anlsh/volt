(in-package :volt)

(defmacro sethash ((key val) table)
  `(setf (gethash ,key ,table) ,val))
