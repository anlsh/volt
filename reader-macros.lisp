;; Macro for inline hash tables
(in-package :volt)
(nrt:in-readtable readtable)

(defun in-place-hash (stream char)
  (declare (ignore char))
  (let ((ls (read-delimited-list #\} stream t)))
    (alx:with-gensyms (table)
      `(let ( (,table (gcl:make-hash-map)))
         ,@(mapcar (lambda (p) (if (listp p)
                                   `(setf (gcl:get ,(car p) ,table) ,(cadr p))
                                   `(setf (gcl:get ,p ,table) t)))
                   ls)
         ,table))))

(set-macro-character #\{ #'in-place-hash)
(set-syntax-from-char #\} #\))

(defun bracketed-access (stream char)
  ;; Roughly, translates [place i1 i2] to place[i1][i2] via the "access" library
  (declare (ignore char))
  (destructuring-bind (place i0 &rest indices) (read-delimited-list #\] stream t)
    (when indices (error "bracketed-access ignores the &rest indices argument but is passed here"))
    `(gcl:elt ,place ,i0)))

(set-macro-character #\[ #'bracketed-access)
(set-syntax-from-char #\] #\))
