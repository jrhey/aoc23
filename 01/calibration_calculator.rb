# frozen_string_literal: true

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
