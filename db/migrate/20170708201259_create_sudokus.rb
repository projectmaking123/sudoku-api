class CreateSudokus < ActiveRecord::Migration[5.1]
  def change
    create_table :sudokus do |t|
      t.string :puzzle

      t.timestamps
    end
  end
end
