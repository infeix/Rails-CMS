class AddIsSubscriberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_subscriber, :boolean
  end
end
