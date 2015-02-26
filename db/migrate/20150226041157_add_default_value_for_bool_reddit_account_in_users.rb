class AddDefaultValueForBoolRedditAccountInUsers < ActiveRecord::Migration
  def change
    change_column_default(:users, :reddit, false)
  end
end
