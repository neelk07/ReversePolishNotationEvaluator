ReversePolishNotationEvaluator
==============================

An implementation of a reverse polish notation evaluator in Ruby

ex: "1 2 +" evaluates to "3"

ex: "2 3 4 + *" evaluates to "14"

Usage
=====

Download the files and run:

```ruby
ruby rpn.rb "{EXPRESSION}"
```

EXPRESSION = expression to evaluate using reverse polish notation (EXPRESSION must be wrapped in " ")

```ruby
ruby rpn.rb "1 2 +" 
=> "SUCCESS: 1 2 + = 3")
```

