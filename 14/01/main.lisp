(load "md5.lisp")

; input string
(defvar input "")

(defun findKey (i)    
    (defvar h (md5:digest-hex (concatenate 'string input i))))
    (write h)
)

(loop for i from 1 to 10
    do(findKey i)
)
