class CreateApifySchedulerUnits < ActiveRecord::Migration
  def change
    create_table :apify_scheduler_units do |t|
      t.string :name, null: false
      t.text :description
      t.text :pattern, null: false
      t.integer :delay, default: 0, null: false
      t.integer :processes, default: 2, null: false
      t.string :destination, null: false

      t.belongs_to :apify_scheduler_server

      t.integer :frequency_quantity
      t.belongs_to :apify_scheduler_frequency_period
      t.string :at

      t.timestamps
    end

    add_index :apify_scheduler_units, :name, unique: true
    add_index :apify_scheduler_units, :apify_scheduler_frequency_period_id, name: :frequency_id
    add_index :apify_scheduler_units, :apify_scheduler_server_id
  end
end
