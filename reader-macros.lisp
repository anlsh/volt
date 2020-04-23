;; Macro for inline hash tables
(in-package :volt)

;; Following code modified from https://news.ycombinator.com/item?id=1611090
;; It has serious bugs, yes I know :P
(defun hash-table-from-pairs (pairs)
  (let ((table (make-hash-table :test #'equalp)))
    (mapcar (lambda (pair) (sethash ((eval (first pair)) (eval (second pair))) table))
            pairs)
    table))

(defun in-place-hash (stream char)
  (declare (ignore char))
  `(hash-table-from-pairs ',(read-delimited-list #\} stream t)))

(set-macro-character #\{ #'in-place-hash)
(set-syntax-from-char #\} #\))
