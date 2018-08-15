class AddIndexToCatRentalRequests < ActiveRecord::Migration[5.2]
  def change
      add_index :cat_rental_requests, :user_id
  end
end
