class CreateQueuedProcesses < ActiveRecord::Migration[8.0]
  def change
    create_table :queued_processes do |t|
      t.integer :status
      t.uuid :process_id
      t.string :file
      t.string :output

      t.timestamps
    end

    add_index :queued_processes, :process_id, unique: true
  end
end
