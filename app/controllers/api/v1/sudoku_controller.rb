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
        elsif (params[:id]).to_s == "create easy"
          new_puzzle = puzzle.create_easy_puzzle
          render json: {status: 'SUCCESS', message: 'solved puzzle', data: new_puzzle }, status: :ok
        else
          render json: {status: 'FAILED', message: 'Please input valid puzzle', data: "invalid puzzle" }, status: :ok
        end
      end
    end
  end
end
