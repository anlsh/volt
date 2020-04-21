(in-package :volt)

(defmacro sethash ((key val) table)
  `(setf (gethash ,key ,table) ,val))

(defmacro put-if-absent ((key val) table)
  (let ((keyvar (gensym)) (tablevar (gensym)))
    `(let ((,keyvar ,key) (,tablevar ,table))
       (unless (second (multiple-value-list (gethash ,keyvar ,tablevar)))
         (sethash (,keyvar ,val) ,tablevar)))))
