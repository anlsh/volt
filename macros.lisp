(in-package :volt)

(defmacro sethash ((key val) table)
  `(setf (gethash ,key ,table) ,val))

(defmacro put-if-absent (key val table)
  (alx:once-only (key table)
    `(unless (second (multiple-value-list (gethash ,key ,table)))
       (sethash (,key ,val) ,table))))
