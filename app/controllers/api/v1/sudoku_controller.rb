module Api
  module V1
    class SudokuController < ApplicationController
      def index
        render json: {status: 'SUCCESS', message: 'solved puzzle', data: "generate" }, status: :ok
      end

      def show
        puzzle = Sudoku.first
        params.inspect
        if (params[:id]).split("").count == 81
          solved = puzzle.solve(params[:id])
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: solved }, status: :ok
        elsif (params[:id]).split("")[0..7].join("") == "validate" && (params[:id]).split("").count >= 80
          newPuzzle = (params[:id]).split("")[8..-1]
          solved = puzzle.input_validate(newPuzzle.join(""))
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: solved }, status: :ok
        elsif (params[:id]).to_s == "generate"
          solved = puzzle.solve("---------------------------------------------------------------------------------")
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: solved }, status: :ok
        elsif (params[:id]).to_s == "check"
          new_puzzle = puzzle.create_easy_puzzle
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: new_puzzle }, status: :ok
        elsif (params[:id]).to_s == "create easy puzzle"
          new_puzzle = puzzle.create_easy_puzzle
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: new_puzzle }, status: :ok
        elsif (params[:id]).to_s == "create hard puzzle"
          new_puzzle = puzzle.create_hard_puzzle
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: new_puzzle }, status: :ok
        elsif (params[:id]).to_s == "create genius puzzle"
          new_puzzle = puzzle.create_genius_puzzle
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: new_puzzle }, status: :ok
        else
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: "red" }, status: :ok
        end
      end
    end
  end
end
