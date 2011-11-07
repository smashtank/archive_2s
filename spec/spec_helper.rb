$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'active_record'
require 'action_controller'
require 'rspec'
require 'archive_2s'
require 'sqlite3'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end

#ActiveRecord::Schema.verbose = false
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Base.configurations = true
ActiveRecord::Schema.define(:version => 1) do
  create_table :items do |t|
    t.datetime  :created_at
    t.datetime  :updated_at
    t.string    :name
    t.string    :description
  end

  create_table :things do |t|
    t.datetime  :created_at
    t.datetime  :updated_at
    t.string    :name
    t.string    :description
  end

  create_table :archived_to_s do |t|
    t.datetime  :archived_at
    t.string    :model_type
    t.integer   :model_id
    t.string    :archived_value
  end
  add_index :archived_to_s, [:model_type,:model_id,:archived_at], :name => 'model_and_archive_date_idx', :unique => true
end

