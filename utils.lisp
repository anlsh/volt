(in-package :volt)

(defun transpose (list-of-lists)
  (apply #'mapcar #'list list-of-lists))

(defun set-contains (key set)
  (second (multiple-value-list (gethash key set))))

(defun set-add (key set)
  (setf (gethash key set) t))

(defun list-to-set (list &key (test #'equal))
  (let ((set (make-hash-table :test test)))
    (mapcar (lambda (p) (set-add p set)) list)
    set))
