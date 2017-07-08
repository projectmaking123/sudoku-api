module Api
  module V1
    class SudokuController < ApplicationController
      def index
        render json: {status: 'SUCCESS', message: 'solved puzzle', data: "Hello" }, status: :ok
      end

      def show
        puzzle = Sudoku.first
        solved = puzzle.solve(params[:id])
        render json: {status: 'SUCCESS', message: 'solved puzzle', data: solved }, status: :ok
      end
    end
  end
end
