class CreateFaspClientProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_client_providers do |t|
      t.string :name
      t.string :base_url
      t.string :server_id
      t.string :public_key

      t.timestamps
    end
  end
end
