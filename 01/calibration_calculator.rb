# frozen_string_literal: true

##########
# PART 1 #
##########

def calculate_calibration(filename)
  calibration_sum = 0
  File.read(filename).each_line do |word|
    calibration_sum += calibration_from_word(word)
  end
  calibration_sum
end

def calibration_from_word(word)
  numbers = []
  word.each_char do |char|
    num = char.to_i
    numbers << num if num.to_s == char
  end
  return 0 if numbers.size <= 0

  "#{numbers.first}#{numbers.last}".to_i
end

puts calculate_calibration('./calibration_input.txt')

##########
# PART 2 #
##########

NUM_MAP = { '0' => 0, '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9,
            'zero' => 0, 'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5, 'six' => 6,
            'seven' => 7, 'eight' => 8, 'nine' => 9 }.freeze

# nums_from_word('one1two8three')
# [[0, 1], [3, 1], [4, 2], [7, 8], [8, 3]]
def nums_from_word_with_index(word)
  nums = {}
  NUM_MAP.each do |k, v|
    word.scan(k) { nums.merge!({ Regexp.last_match.begin(0) => v }) }
  end
  nums.sort
end

def calculate_calibration_including_words(filename)
  calibration_sum = 0
  File.read(filename).each_line do |line|
    nums_with_index = nums_from_word_with_index(line)
    calibration_sum += "#{nums_with_index.first.last}#{nums_with_index.last.last}".to_i
  end
  calibration_sum
end

test_answer = nums_from_word_with_index('3fouronebnclssixfour6eight')
expectation = [[0, 3], [1, 4], [5, 1], [13, 6], [16, 4], [20, 6], [21, 8]]

puts 'expected: '
pp expectation

puts 'got: '
pp test_answer
puts test_answer == expectation

puts calculate_calibration_including_words('./calibration_input.txt')
