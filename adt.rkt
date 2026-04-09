#lang racket

(provide (all-defined-out))

(define (value? expr)
  (or (primitive? expr)
      (closure? expr)
      ;; Check for built-in procedures
      (procedure? expr))) 

;; Helper functions for tagged data
(define (attach-tag content tag)
  (cons tag content))

(define (get-tag tagged)
  (car tagged))

(define (get-content tagged)
  (cdr tagged))

(define (tagged-by? tagged tag)
  (and (pair? tagged)
       (eq? (get-tag tagged) tag)))

;; Generic Constructor
(define (make-expression type data)
  (attach-tag data type))

;; Generic Accessor
(define (ref data index)
  (list-ref data index))

;; Replace atomic? with new implementations
(define (atomic? expr)
  (or (symbol? expr)
      (primitive? expr)))

(define (primitive? expr)
  (or (number? expr)
      (boolean? expr)
      (string? expr)))

;; ==========================================
;; Core Expressions
;; ==========================================

;; --- if ---
(define (make-if test then else)
  (make-expression 'if (list test then else)))

(define (if? expr)
  (tagged-by? expr 'if))

(define (if-test expr)
  (ref (get-content expr) 0))

(define (if-then expr)
  (ref (get-content expr) 1))

(define (if-else expr)
  (ref (get-content expr) 2))

;; --- lambda ---
(define (make-lambda params body)
  (make-expression 'lambda (list params body)))

(define (lambda? expr)
  (tagged-by? expr 'lambda))

(define (lambda-params expr)
  (ref (get-content expr) 0))

(define (lambda-body expr)
  (ref (get-content expr) 1))

;; --- application ---
(define (make-application operator operands)
  (cons operator operands))  

(define (application? expr)
  (and (list? expr)
       (not (null? expr))))

(define (application-operator expr)
  (car expr)) ;; First element: operator

(define (application-operands expr)
  (cdr expr)) ;; Remaining: operands

;; --- closure ---
(define (make-closure params body)
  (make-expression 'closure
                   (list params body)))

(define (closure? expr)
  (tagged-by? expr 'closure))

(define (closure-params expr)
  (ref (get-content expr) 0))

(define (closure-body expr)
  (ref (get-content expr) 1))

;; --- cond ---
(define (make-cond clauses)
  (make-expression 'cond clauses))

(define (cond? expr)
  (tagged-by? expr 'cond))

(define (cond-clauses expr)
  (get-content expr))

;; --- let ---
(define (make-let bindings body)
  (make-expression 'let (list bindings body)))

(define (let? expr)
  (tagged-by? expr 'let))

(define (let-bindings expr)
  (ref (get-content expr) 0))

(define (let-body expr)
  (ref (get-content expr) 1))

(define (let-vars expr)
  (map car (let-bindings expr)))

(define (let-vals expr)
  (map cadr (let-bindings expr)))

;; --- let* ---
(define (make-let* bindings body)
  (list 'let* bindings body))

(define (let*? expr)
  (and (list? expr) (eq? (car expr) 'let*)))

(define (let*-bindings expr)
  (cadr expr))

(define (let*-body expr)
  (caddr expr))

;; --- define ---
(define (make-define variable value)
  (make-expression 'define (list variable value)))

(define (define? expr)
  (tagged-by? expr 'define))

(define (define-variable expr)
  (ref (get-content expr) 0))

(define (define-value expr)
  (ref (get-content expr) 1))

;; --- set! ---
(define (make-set! var val) 
  (list 'set! var val))

(define (set!? expr) 
  (and (list? expr) (eq? (car expr) 'set!)))

(define (set-variable expr) 
  (cadr expr))

(define (set-value expr) 
  (caddr expr))

;; --- Function Definition ---
;; Constructor
(define (make-function-definition name params body)
  ;; Attach 'define tag with structured content
  (make-expression 'define (list (cons name params) body))) 

;; Predicate
(define (function-definition? exp)
  ;; Check if tagged as 'define
  (and (define? exp)               
       ;; Ensure variable part is a list
       (list? (ref (get-content exp) 0)))) 

;; Selectors
(define (function-definition-variable exp)
  ;; Function name
  (car (ref (get-content exp) 0))) 

(define (function-definition-parameters exp)
  (cdr (ref (get-content exp) 0)))

(define (function-definition-body exp)
  (ref (get-content exp) 1))


(module+ main
  (displayln "module loaded"))