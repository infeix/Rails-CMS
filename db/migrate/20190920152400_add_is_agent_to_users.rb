class AddIsAgentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_agent, :boolean
  end
end
