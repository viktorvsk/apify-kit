class CreateApifyServers < ActiveRecord::Migration
  def change
    create_table :apify_scheduler_servers do |t|
      t.string :name
      t.string :url
      t.text :description
      t.string :api_key

      t.timestamps
    end

    add_index :apify_scheduler_servers, :name, unique: true
  end
end
