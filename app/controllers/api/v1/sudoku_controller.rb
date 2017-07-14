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
        elsif (params[:id]).to_s == "generate"
          solved = puzzle.solve("---------------------------------------------------------------------------------")
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: solved }, status: :ok
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
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: "invalid" }, status: :ok
        end
      end
    end
  end
end
