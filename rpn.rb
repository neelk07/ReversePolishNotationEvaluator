module RPNEvaluator

  OPERATORS = ['+', '-', '*', '/']

  # Description: calculates result of formatted expression using two stacks
  # Input: list of numbers and symbols in order
  # Valid: if correct number and type of numbers and operators passed
  # Return: Integer
  # Raises: exception if invalid
  def evaluate_expression(input_list)
    int_stack = []
    operator_stack = []
    for input in input_list
      #encountered numerical values so add to int_stack
      if input.kind_of? Integer or input.kind_of? Float
        int_stack.push(input)
      #encountered operator so perform operator and then add result to int_stack
      else
        num_one = int_stack.pop()
        num_two = int_stack.pop()
        if num_one == nil or num_two == nil
          #raise invalid expression exception: not enough numbers
          raise "not enough arguments"
        end

        result = case input
                 when "*" then num_two * num_one
                 when "+" then num_two + num_one
                 when "-" then num_two - num_one
                 when "/" then num_two / num_one
                 else raise "invalid operator"
                 end

        int_stack.push(result)
      end

    end

    if int_stack.length > 1
      #raise invalid expression exception: too many numbers not enough operators
      raise "not enough arguments"
    else
      return int_stack.pop()
    end

  end

  # Description: checks expression for valid numbers and symbols/operators
  # Input: String
  # Valid: if all words are either numbers or valid symbols (+ - * /)
  # Return: List of Strings (tokenized expression)
  # Raises: exception if invalid (indirect from atoi or atof)
  def validate_and_format_expression(expression)
    words = expression.split(" ")
    formatted_list = []
    for word in words
      if OPERATORS.include?(word)
        formatted_list << word
      else
        word = (if word.include? '.' then atof(word) else atoi(word) end)
        formatted_list << word
      end
    end

    return formatted_list
  end

  # Description: checks passed in argument for correct format (see valid)
  # Input: List of Strings
  # Valid: if only one non-nil commandline argument is passed
  # Return: String (argument passed thru command line)
  # Raises: exception if invalid
  def read_and_validate_arguments(arg)
    #handle error for more than one argument
    if arg.empty?
      raise "no expression provided"
    elsif arg.length > 1
      raise "more than 1 expression given"
    else
      ret = arg.shift
      return ret
    end

  end

  # Description: converts number in String format to Integer format
  # Input: string representation of number
  # Valid: all characters have to be in valid ascii range (48-57) for integers
  # Return: Integer
  # Raises: exception if invalid
  def atoi(input)
    neg = if input[0] == "-" then true else false end
    if neg
      input.slice!(0)
    end

    number = 0
    for char in input.chars
      #substract by offset to get integer value
      integer = char.ord - 48
      if integer > 9 or integer < 0
        #raise exception for invalid number
        raise "invalid number or operator"
      else
        number = number * 10
        number = number + integer
      end

    end

    if neg
      return -number
    else
      return number
    end

  end

  # Description: converts number in String format to Float format
  # Input: string representation of number
  # Valid: all characters have to be in valid ascii range (48-57) for integers
  # Return: Float
  # Raises: exception if invalid
  def atof(input)
    split = input.split(".")
    number = atoi(split[0])
    divisor = 10
    neg = if number < 0 then true else false end

    for char in split[1].chars
      #substract by offset to get integer value
      integer = char.ord - 48
      if integer > 9 or integer < 0
        #raise exception for invalid number
        raise "invalid number or operator"
      else
        #different operation based on sign in front
        if neg
          number = number - integer.fdiv(divisor)
        else
          number = number + integer.fdiv(divisor)
        end

        divisor = divisor * 10
      end

    end

    return number
  end

end #end of module




#main method
  if __FILE__ == $PROGRAM_NAME
    begin
      include RPNEvaluator
      input = RPNEvaluator.read_and_validate_arguments(ARGV)
      input_list = RPNEvaluator.validate_and_format_expression(input)
      result = RPNEvaluator.evaluate_expression(input_list)
    rescue => e
      puts "ERROR: #{input} (#{e.message})"
    else
      puts "SUCCESS: #{input} = #{result}"
    end

  end

