# frozen_string_literal: true

# Counts max cube per game
class PuzzleSolver
  attr_reader :game_ids_below_ceiling

  def initialize(filename, cube_ceiling)
    @filename = filename
    @cube_ceiling = cube_ceiling
    @game_ids_below_ceiling = []
  end

  def solve
    File.read(@filename).each_line do |game_row|
      row = game_row.split(':')
      game_id = row.first.split(' ').last
      game = clean_game_row(row.last)
      cube_counts = max_cubes_for_game(game)
      @game_ids_below_ceiling << game_id if below_ceiling?(cube_counts)
    end
    @game_ids_below_ceiling.map(&:to_i).sum
  end

  def solve_2
    sum_of_powers = []
    File.read(@filename).each_line do |game_row|
      row = game_row.split(':')
      game = clean_game_row(row.last)
      cube_counts = max_cubes_for_game(game)
      sum_of_powers << cube_counts['red'] * cube_counts['green'] * cube_counts['blue']
    end
    sum_of_powers.map(&:to_i).sum
  end

  def below_ceiling?(cubes)
    rubes['red'] <= @cube_ceiling['red'] &&
      cubes['blue'] <= @cube_ceiling['blue'] &&
      cubes['green'] <= @cube_ceiling['green']
  end

  def max_cubes_for_game(game)
    cube_counts = { 'red' => 0, 'blue' => 0, 'green' => 0 }
    game.each do |sets|
      sets.each do |cube_quant|
        cube_and_count = cube_quant.split(' ')
        quantity = cube_and_count.first.to_i
        color = cube_and_count.last
        cube_counts[color] = quantity if cube_counts[color] < quantity
      end
    end
    cube_counts
  end

  # Returns a game in a clean parseable format
  # [["1 green"], ["2 green", "1 blue"], ["1 red"]]
  def clean_game_row(game_row)
    game_row.split(';').map { |set| set.split(',').map(&:strip) }
  end
end

# tests
# Game 1: 9 red, 2 green, 13 blue; 10 blue, 2 green, 13 red; 8 blue, 3 red, 6 green; 5 green, 2 red, 1 blue
cube_ceiling = { 'red' => 12, 'blue' => 14, 'green' => 13 }

expectation = { 'red' => 2, 'blue' => 3, 'green' => 2 }
puzzle_solver_test = PuzzleSolver.new('./puzzle_input.txt', cube_ceiling)
got = puzzle_solver_test.max_cubes_for_game([['1 red', '2 green', '1 blue'], ['2 red', '1 green', '3 blue']])
pp expectation
pp got
pp got == expectation

puzzle_solver = PuzzleSolver.new('./puzzle_input.txt', cube_ceiling)
puts puzzle_solver.solve
puts puzzle_solver.solve_2
