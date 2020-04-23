;; Macro for inline hash tables
(in-package :volt)

(labels ((in-place-hash (stream char)
           (declare (ignore char))
           (let ((ls (read-delimited-list #\} stream t)))
             (with-gensyms (table)
               `(let ( (,table (make-hash-table :test #'equalp)))
                  ,@(mapcar (lambda (p) `(setf (gethash ,(car p) ,table) ,(cadr p)))
                            ls)
                  ,table)))))
  (set-macro-character #\{ #'in-place-hash))

(set-syntax-from-char #\} #\))
