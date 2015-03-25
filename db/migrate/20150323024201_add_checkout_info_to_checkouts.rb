class AddCheckoutInfoToCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :question, :text
    add_column :checkouts, :solved_problem, :text
    add_column :checkouts, :github_repository, :string
    add_column :checkouts, :degree_of_difficulty, :integer
    #minute
    add_column :checkouts, :time_cost, :integer
  end
end
