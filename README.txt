# Racket Interpreter: Substitution and Environment Models

This project implements an evaluator (interpreter) for a subset of the Racket/Scheme language. It was inspired by and built for the **Principles of Programming Languages (PPL)** academic course.

## What is an Evaluator?

An **Evaluator** is the heart of any interpreter. While a parser's job is to read the raw code and turn it into a structured format (an Abstract Syntax Tree, or AST), the evaluator's job is to actually *run* that code. It takes the parsed expressions and computes their results based on the rules (semantics) of the language. 

In this project, the evaluation of expressions is demonstrated using two distinct computational models:
* **The Substitution Model:** Evaluates expressions by mechanically substituting values for variables directly within the expression's body.
* **The Environment Model:** Evaluates expressions by maintaining "environments" (frames of memory) that keep track of variable bindings, which is closer to how modern programming languages manage memory and scope.

## Features

* **Interactive CLI Menu:** A user-friendly console menu to navigate the program.
* **Dual Evaluators:** Choose seamlessly between the Substitution Model and the Environment Model.
* **Automated Testing:** Run a predefined suite of tests to verify the core functionality (e.g., `define`, `lambda`, `let`, `if`, `cond`).
* **Custom REPL:** Enter your own custom expressions interactively and evaluate them on the fly.

## Project Structure

* `main.rkt` - The main entry point containing the interactive menu and test runner.
* `adt.rkt` - Abstract Data Types used across the project.
* `parser.rkt` - Parses raw expressions into AST nodes.
* `models/Substitution-Model/evaluator.rkt` - The evaluation logic based on the substitution of variables.
* `models/Environment-Model/env-evaluator.rkt` - The evaluation logic based on environments and frames.

## How to Run

1. Ensure you have [Racket](https://racket-lang.org/) installed on your machine.
2. Clone this repository to your local machine.
3. Open `main.rkt` in DrRacket.
4. Click **Run** (or press `Ctrl+R` / `Cmd+R`).
5. Follow the on-screen instructions in the console to choose a model and run tests or custom expressions.

## Example Usage

When you run the project, you will see the following menu:

```text
=== Model Selection ===
1. Substitution Model
2. Environment Model
3. Exit Program
Please select a model (1-3):