class CreateApifyHistories < ActiveRecord::Migration
  def change
    create_table :apify_scheduler_histories do |t|

      t.text :response_body
      t.belongs_to :apify_scheduler_unit
      t.boolean :queued, default: false

      t.datetime :finished_at, default: nil
      t.timestamps
    end
  end
end
