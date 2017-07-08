class Sudoku < ApplicationRecord
  validates :puzzle, presence: true

  def sudoku_generator(board)
    new_board = just_a_box(initial(board)).map.with_index do |row, i|
      if i == 6 || i == 2
        by_design(row)
      else
        row
      end
    end
    testing(unbox(new_board))
  end

  def validate(board)
    checkbox = [board, board.transpose, just_a_box(board)]
    checkbox.all? do |check|
      check.all? do |row|
        row.select {|ele| ele.is_a?(String) && ele != "-" && ele != "0"} == row.select {|ele| ele.is_a?(String) && ele != "-" && ele != "0"}.uniq
      end
    end
  end

  def last_hope(board)
    new_board = advanced_solving(initial(board), [])
    final_board = just_a_box(new_board).map.with_index do |row, i|
      if i == 0 || i == 4 || i == 8
        by_design(row)
      else
        row
      end
    end
    if validate(unbox(final_board))
      if check(rotation(unbox(final_board), []))
        return rotation(unbox(final_board), [])
      else
        last_hope(board)
      end
    else
      last_hope(board)
    end
  end

  def by_design(row)
    numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    guesses = []
    row.each do |ele|
      if ele.is_a?(Array)
        ele = ele - guesses
        guesses << ele.shuffle[0]
      else
        guesses << ele
      end
    end

   if guesses.compact.sort == numbers
     return guesses
   else
     by_design(row)
   end
  end

  def sum_count(board)
    sum = []
    board.each do |row|
      sum << row.count {|ele| (ele != "-" && ele != "0") && ele.class != Array}
    end
    sum.reduce(:+)
  end

  def testing(board)
    if validate(board) == false
      puts "Invalid board"
    elsif sum_count(board) > 23
      guess_solving(initial(board))
    elsif sum_count(board) < 23 && sum_count(board) > 0
      last_hope(initial(board))
    elsif sum_count(board) == 0
      sudoku_generator(board)
    end
  end

  def guess_solving(board)
    new_board = advanced_solving(board, [])
    if check(new_board)
      return new_board
    elsif check(advanced_solving(guess(new_board), []))
      return advanced_solving(new_board, [])
    else
      return guess_solving(board)
    end
  end

  def guess(board)
    new_board = board
    collection = []

    new_board.each_with_index do |row, x|
      row.each_with_index do |ele, y|
        if ele.is_a?(Array) && ele.empty? == false
          collection << [x, y]
        end
      end
    end

      first = collection.first
      new_board[first[0]][first[1]] = new_board[first[0]][first[1]].shuffle[0]

      if check(advanced_solving(new_board, []))
        return advanced_solving(new_board, [])
      end

      final = collection.last
      new_board[final[0]][final[1]] = new_board[final[0]][final[1]].shuffle[0]

      if check(advanced_solving(new_board, []))
        return advanced_solving(new_board, [])
      end
    board
  end

  def advanced_solving(board, store)
    if check(board)
      return board
    end
    if store[-1] == (board)
      return board
    else
      store << board
      advanced_solving(advanced_box(board), store)
    end
  end

  def advanced_search(board)
    board = rotation(board, [])
    new_board = []
    board.each do |row|
      arrays = []
      row.each do |ele|
        if ele.is_a?(Array)
          arrays << ele
        end
      end

      uniq_numbers = arrays.flatten.find_all{ |e| arrays.flatten.count(e) == 1 }

      row.map do |ele|
        uniq_numbers.each do |num|
            if ele.include?(num)
              ele.clear[0] = num
              ele = ele[0]
            else
              ele
            end
          end
        end
        new_board << row
      end
      rotation(new_board, [])
    end

  def advanced_vert(board)
    new_board = advanced_search(advanced_search(board).transpose)
    advanced_search(new_board.transpose)
  end

  def advanced_box(board)
    box = just_a_box(advanced_vert(advanced_search(board)))
    unbox(box)
  end

  def check(board)
    checkbox = [board, board.transpose, just_a_box(board)]
    checkbox.all? do |check|
      check.all? do |row|
        row == row.uniq &&
        row.all? do |ele|
          ele.is_a?(String)
        end
      end
    end
  end

  def rotation(board, store)
    if check(board)
      return board
    end
    if store[-1] == (board)
      return board
    else
      store << board
    end
    rotation(box_maker(vert(board)), store)
  end

  def vert(board)
    search(board.transpose, []).transpose
  end

  def convert(board)
    new_board = board.map do |row|
        row.map do |ele|
          if ele.is_a?(Array) && ele.length == 1
            ele = ele[0]
          else
            ele
          end
        end
      end
    new_board
  end


  def unbox(box)
    unboxed = []

    9.times { unboxed << [] }

    second = box.map do |row|
      row.rotate(3)
    end

    third = box.map do |row|
      row.rotate(6)
    end

    i = 0
    while i < 9
      x = 0
      while x < 3
        unboxed[0] << box[i][x]
        x += 1
      end
      i += 3
    end

    i = 0
    while i < 9
      x = 3
      while x < 6
        unboxed[1] << box[i][x]
        x += 1
      end
      i += 3
    end

    i = 0
    while i < 9
      x = 6
      while x < 9
        unboxed[2] << box[i][x]
        x += 1
      end
      i += 3
    end


    i = 1
    while i < 9
      x = 0
      while x < 3
        unboxed[3] << box[i][x]
        x += 1
      end
      i += 3
    end

    i = 1
    while i < 9
      x = 3
      while x < 6
        unboxed[4] << box[i][x]
        x += 1
      end
      i += 3
    end

    i = 1
    while i < 9
      x = 6
      while x < 9
        unboxed[5] << box[i][x]
        x += 1
      end
      i += 3
    end

    i = 2
    while i < 9
      x = 0
      while x < 3
        unboxed[6] << box[i][x]
        x += 1
      end
      i += 3
    end

    i = 2
    while i < 9
      x = 3
      while x < 6
        unboxed[7] << box[i][x]
        x += 1
      end
      i += 3
    end

    i = 2
    while i < 9
      x = 6
      while x < 9
        unboxed[8] << box[i][x]
        x += 1
      end
      i += 3
    end
    search(unboxed, [])
  end

  def just_a_box(board)
    box = []
    second = board.map { |row| row.rotate(3) }
    third = board.map { |row| row.rotate(6) }
    flat(slicer(board)).each { |i| box << i }
    flat(slicer(second)).each { |i| box << i }
    flat(slicer(third)).each { |i| box << i }
    box
  end

  def box_maker(board)
    unbox(search(just_a_box(board), []))
  end

  def slicer(board)
    sliced = []
    board.each do |row|
      sliced << row[0..2]
    end
    sliced
  end

  def flat(sliced)
    boxed = []
    sliced.each do |ele|
      ele.each do |i|
        boxed << i
      end
    end
    boxed.each_slice(9).to_a
  end

  def search(board, store)
    new_board = []
    board.each do |row|
      solved = []
      row.each do |num|
        if num.is_a?(String)
          solved << num
        end
      end
      row.each do |ele|
        if ele.is_a?(Array)
          ele = ele - solved
          new_board << ele
        else
          new_board << ele
        end
      end
    end
    new_board = convert(new_board.each_slice(9).to_a)
    if new_board == store[-1]
      return new_board
    else
      store << new_board
      search(new_board, store)
    end
  end

  def initial(board)
    numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    stored = []
    board.each do |row|
      solved = []
      row.each do |num|
        if num != "-" || num != "0"
          solved << num
        end
      end
      row.each do |dash|
        if dash == "-" || dash == "0"
          stored << numbers
        else
          stored << dash
        end
      end
    end
    stored.each_slice(9).to_a
  end

  def starting(board_string)
    board_string.chars.each_slice(9).to_a
  end

  def solve(string)
    testing(starting(string)).flatten
  end
end
