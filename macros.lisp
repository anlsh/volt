(in-package :volt)

(defmacro sethash ((key val) table)
  `(setf (gethash ,key ,table) ,val))

(defmacro put-if-absent (key val table)
  (alx:once-only (key table)
    `(unless (second (multiple-value-list (gethash ,key ,table)))
       (sethash (,key ,val) ,table))))


(defmacro pythonic-import (imports &rest body)
  ;; Imports has form
  ;;     (package-name (symbol-to-import | symbol-to-import nickname)*)*
  (let ((replacement-map (fset:empty-map)))
    (arrow-macros:-<> imports
      (mapcar (lambda (pkg-spec)
                (let ((pkg-name (car pkg-spec)))
                  (mapcar (lambda (sym-spec)
                            (if (symbolp sym-spec)
                                (list sym-spec
                                      (find-symbol (symbol-name sym-spec)
                                                   pkg-name))
                                (list (car sym-spec)
                                      (find-symbol (symbol-name (cadr sym-spec))
                                                   pkg-name))))
                          (cdr pkg-spec))))
              arrow-macros:<>)
      (apply #'append arrow-macros:<>)
      (mapcar (lambda (x) (fset:adjoinf replacement-map (car x) (cadr x)))
              arrow-macros:<>))
    (labels ((replace-symbols (x)
               (cond ((listp x) (mapcar #'replace-symbols x))
                     ((symbolp x) (multiple-value-bind (new-sym in?) (fset:@ replacement-map x)
                                    (if in? new-sym x)))
                     (t x))))
      `(progn ,@(replace-symbols body)))))
