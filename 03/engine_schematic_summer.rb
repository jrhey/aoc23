# frozen_string_literal: true

# Sums all schemas in engine schematic
class EngineSchematicSummer
  attr_reader :num_chunks, :symbol_chunks, :parsed_chars

  def initialize(filename)
    @filename = filename
    @num_chunks = []
    @symbol_chunks = []
    @parsed_chars = []
  end

  def sum
    set_indices_of_chunks_and_symbols
    sum_chunks_near_symbols
  end

  VALID_NUMBERS = %w[1 2 3 4 5 6 7 8 9 0]

  # Sets all indices of found numbers and symbols in chunks of arrays
  # [[[0, 1, 2], [5, 6, 7]], [], [[2, 3], [6, 7, 8]], [], [[0, 1, 2]], [[7, 8]], [[2, 3, 4]], [[6, 7, 8]], [], [[1, 2, 3], [5, 6, 7]]]
  # [[-1], [3], [-1], [6], [3], [5], [-1], [-1], [3, 5], [-1]]
  def set_indices_of_chunks_and_symbols
    File.read(@filename).each_line do |current_row|
      found_a_symbol_this_row = false
      contiguous_number = []
      row_of_contiguous_numbers = []
      row_of_symbols = []
      row_of_chars = []
      last_index = current_row.strip.size - 1
      current_row.strip.split('').each_with_index do |current_char, index_of_current_char|
        row_of_chars << current_char

        char_to_number = current_char.to_i
        if char_to_number.to_s == current_char
          contiguous_number << index_of_current_char
        elsif current_char != '.'
          row_of_symbols << index_of_current_char
          found_a_symbol_this_row = true
        end

        if !contiguous_number.empty? && !VALID_NUMBERS.include?(current_char) || index_of_current_char == last_index
          row_of_contiguous_numbers << contiguous_number
          contiguous_number = []
        end

        next if found_a_symbol_this_row && index_of_current_char != last_index

        row_of_symbols << -1
      end
      @parsed_chars << row_of_chars
      @num_chunks << row_of_contiguous_numbers
      @symbol_chunks << row_of_symbols
    end
  end

  def sum_chunks_near_symbols
    sum = 0
    @symbol_chunks.each_with_index do |symbol_chunk, row_index|
      symbol_chunk.each do |sym_index|
        next if sym_index == -1

        [row_index - 1, row_index, row_index + 1].each do |row_to_check|
          next if row_index.negative?

          @num_chunks[row_to_check].each do |num_chunk|
            next unless chunk_is_near_symbol?(num_chunk, sym_index)

            nums = parsed_chars[row_to_check][num_chunk.first..num_chunk.last]
            sum += nums.join.to_i
          end
        end
      end
    end
    sum
  end

  def chunk_is_near_symbol?(num_chunk, sym_index)
    (num_chunk & [sym_index - 1, sym_index, sym_index + 1]).any?
  end
end

# TEST INPUT
#
# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..

test_filename = './03/engine_schematic_test_input.txt'
test_engine_schema_summer = EngineSchematicSummer.new(test_filename)
answer = test_engine_schema_summer.sum
pp test_engine_schema_summer.num_chunks
expectation = 4361

puts "Expected: #{expectation}"
puts "Got: #{answer}"

filename = './03/engine_schematic_input.txt'
engine_schema_summer = EngineSchematicSummer.new(filename)
pp engine_schema_summer.sum
