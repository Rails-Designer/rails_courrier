class CreateCourrierEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :courrier_events do |t|
      t.string :event_type, null: false
      t.json :metadata, default: {}

      t.timestamp :created_at
    end

    add_index :courrier_events, [:event_type, :created_at]
  end
end
