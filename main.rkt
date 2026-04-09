#lang racket

;; Shared ADT and Parser (Used by both models)
(require "adt.rkt"
         "parser.rkt")

;; Evaluator for Substitution Model
(require (prefix-in sub: "models/Substitution-Model/evaluator.rkt"))

;; Evaluator for Environment Model
(require (prefix-in env: "models/Environment-Model/env-evaluator.rkt"))

;; Evaluate and print a single expression using the chosen evaluator
(define (run-single-test expr eval-fn)
  (display "Testing: ") (display expr) (newline)
  (let* ((parsed (parse-expression expr)) ; Shared parser function
         (result (eval-fn parsed)))       ; Specific evaluator function
    (display "Parsed: ") (display parsed) (newline)
    (display "Result: ") (display result) (newline)
    (newline)))

;; Recursive Test Runner for a list of expressions
(define (run-tests tests eval-fn)
  (cond
    ((null? tests)
     (display "All automated tests completed.") (newline) (newline))
    (else
     (run-single-test (car tests) eval-fn)
     (run-tests (cdr tests) eval-fn))))

;; Define Automated Tests
(define tests
  '(  (define x 2)
      x
      (+ 5 5)
      (if #t 1 2)                                      ; `if`
      ((lambda (x) (+ x x)) 5)                         ; `lambda` application
      (let ((x 10)(y 5))
        (+ x y))                                       ; `let`
      (cond ((> 5 3) "greater") ((< 5 3) "less") (else "equal")) ; `cond`
      ))

;; Interactive REPL for custom expressions
(define (custom-repl eval-fn)
  (display "Enter a custom expression (or type 'exit' to return to action menu): ")
  (let ((input (read)))
    (cond
      ((eq? input 'exit)
       (display "Returning to action menu...") (newline) (newline))
      (else
       (run-single-test input eval-fn)
       (custom-repl eval-fn))))) ; Loop back for another custom expression

;; Secondary Menu (Action Selection)
(define (action-menu model-name eval-fn)
  (display "--- ") (display model-name) (display " Menu ---") (newline)
  (display "1. Run automated tests") (newline)
  (display "2. Enter custom expressions") (newline)
  (display "3. Back to Model Selection") (newline)
  (display "Please select an option (1-3): ")
  
  (let ((choice (read)))
    (cond
      ((eq? choice 1)
       (newline)
       (display "Running automated tests...") (newline)
       (run-tests tests eval-fn)
       (action-menu model-name eval-fn)) ; Return to action menu
      
      ((eq? choice 2)
       (newline)
       (custom-repl eval-fn)
       (action-menu model-name eval-fn)) ; Return to action menu
      
      ((eq? choice 3)
       (newline)
       (display "Returning to Model Selection...") (newline) (newline)
       (main-menu)) ; Return to the very first menu
      
      (else
       (newline)
       (display "Invalid choice. Please enter 1, 2, or 3.") (newline) (newline)
       (action-menu model-name eval-fn)))))

;; Main Menu (Model Selection)
(define (main-menu)
  (display "=== Model Selection ===") (newline)
  (display "1. Substitution Model") (newline)
  (display "2. Environment Model") (newline)
  (display "3. Exit Program") (newline)
  (display "Please select a model (1-3): ")
  
  (let ((choice (read)))
    (cond
      ((eq? choice 1)
       (newline)
       (action-menu "Substitution Model" sub:eval_)) ; Pass Substitution evaluator
      
      ((eq? choice 2)
       (newline)
       (action-menu "Environment Model" env:eval_))  ; Pass Environment evaluator
      
      ((eq? choice 3)
       (newline)
       (display "Exiting program. Goodbye!") (newline))
      
      (else
       (newline)
       (display "Invalid choice. Please enter 1, 2, or 3.") (newline) (newline)
       (main-menu)))))

;; Start the program
(main-menu)