class CreateArchive2sModel < ActiveRecord::Migration
  def self.up
    create_table :archived_to_s do |t|
      t.datetime  :archived_at
      t.string    :model_type
      t.integer   :model_id
      t.string    :archived_value
    end
    add_index :archived_to_s, [:model_type,:model_id,:archived_at], :name => 'model_and_archive_date_idx', :unique => true
  end

  def self.down
    drop_table :archived_to_s
  end
end

