require 'minitest/autorun'
require './rpn'
include RPNEvaluator


# Description: TestClass to test our module for correctness and error handling
class TestRPNEvaluator < Minitest::Test
  
  #test atoi function	
  def test_atoi
    assert_equal 0, RPNEvaluator.atoi("0")
    assert_equal 3, RPNEvaluator.atoi("3")
    assert_equal -3, RPNEvaluator.atoi("-3")
    assert_equal -234, RPNEvaluator.atoi("-234")
    assert_equal 1234, RPNEvaluator.atoi("1234")
    assert_raises RuntimeError do RPNEvaluator.atoi("+-*/") end
    assert_raises RuntimeError do RPNEvaluator.atoi("*^@") end
    assert_raises RuntimeError do RPNEvaluator.atoi("42+42") end
  end

  #test atof function
  def test_atof
  	assert_equal 0.0, RPNEvaluator.atof("0.0")
  	assert_equal 3.0, RPNEvaluator.atof("3.0")
  	assert_equal 3.12, RPNEvaluator.atof("3.12") 
  	assert_equal -3.0, RPNEvaluator.atof("-3.0")
  	assert_equal -3.12, RPNEvaluator.atof("-3.12")	#test case caught flaw in atof (adding positive sub . (ex: .85) to negative number)
  	assert_raises RuntimeError do RPNEvaluator.atof("+-*/") end
    assert_raises RuntimeError do RPNEvaluator.atof("*^@") end
    assert_raises RuntimeError do RPNEvaluator.atof("42.4+2") end
  end

  #test read_and_validate_arguments
  def test_read_and_validate_arguments
  	arg = ["3 2 +"] 
  	assert_equal "3 2 +", RPNEvaluator.read_and_validate_arguments(arg)
  	arg = ["3 2 + 2"] #this method does not actually check for expression correctness
  	assert_equal "3 2 + 2", RPNEvaluator.read_and_validate_arguments(arg)
  	arg = []
  	assert_raises RuntimeError do RPNEvaluator.read_and_validate_arguments(arg) end
  	arg = ["3 2 +", "3 2 1 + -"]
  	assert_raises RuntimeError do RPNEvaluator.read_and_validate_arguments(arg) end
  end

  #test validate_and_format_expression
  def test_validate_and_format_expression
  	assert_equal [3, 2, "+"], RPNEvaluator.validate_and_format_expression("3 2 +")
  	assert_equal [3.0, 2.0, "-"], RPNEvaluator.validate_and_format_expression("3.0 2.0 -")
  	assert_equal [3, 2.0, "*"], RPNEvaluator.validate_and_format_expression("3 2.0 *")
  	assert_equal [3.1, 3.12, "+", "-", "*", "/" ], RPNEvaluator.validate_and_format_expression("3.1 3.12 + - * /")
  	assert_equal [-3, -2, "+"], RPNEvaluator.validate_and_format_expression("-3 -2 +")
  	assert_equal [-3.0, -2.0, "-"], RPNEvaluator.validate_and_format_expression("-3.0 -2.0 -")
  	assert_raises RuntimeError do RPNEvaluator.validate_and_format_expression("3 2 ^") end
    assert_raises RuntimeError do RPNEvaluator.validate_and_format_expression("4*4 2 +") end
  end

  #test evaluate_expression
  def test_evaluate_expression
  	assert_equal 3, RPNEvaluator.evaluate_expression([1,2,"+"])
  	assert_equal 2, RPNEvaluator.evaluate_expression([4,2,"/"])
  	assert_equal 14, RPNEvaluator.evaluate_expression([2,3,4,"+","*"])
  	assert_equal 77, RPNEvaluator.evaluate_expression([3,4,"+",5,6,"+","*"])
  	assert_equal 9, RPNEvaluator.evaluate_expression([13,4,"-"])
  	assert_raises RuntimeError do RPNEvaluator.evaluate_expression([3,2,"+",3,4,2,"+"]) end
  	assert_raises RuntimeError do RPNEvaluator.evaluate_expression([3,2,"+","-"]) end
  end

  #test together
  def test_together
  	input = RPNEvaluator.validate_and_format_expression("5 1 2 + 4 * 3 - +")
  	assert_equal 14, RPNEvaluator.evaluate_expression(input)
  	input = RPNEvaluator.validate_and_format_expression("42 3 * 15 + 6 5 - *")
  	assert_equal 141, RPNEvaluator.evaluate_expression(input)
  	input = RPNEvaluator.validate_and_format_expression("5 17 - 52 8 9 6 7 * + - + *")
  	assert_equal -108, RPNEvaluator.evaluate_expression(input)
  	input = RPNEvaluator.validate_and_format_expression("-5 -4 *")
  	assert_equal 20, RPNEvaluator.evaluate_expression(input)
  	input = RPNEvaluator.validate_and_format_expression("2.5 6.0 -3 / +")
  	assert_equal 0.5, RPNEvaluator.evaluate_expression(input)
  	input = RPNEvaluator.validate_and_format_expression("2 -3.0 * -3 -4.0 * -2.0 3 * + +")
  	assert_equal 0.0, RPNEvaluator.evaluate_expression(input)
  	input = RPNEvaluator.validate_and_format_expression("2 -3.0 * -3 4.0 * -2.0 3 * + + -24 -12 + + -6 -10.0 * +")
  	assert_equal 0.0, RPNEvaluator.evaluate_expression(input)
  end

end
