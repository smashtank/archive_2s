class Archive2sModelGenerator < Rails::Generator::Base
  def manifest
    m.migration_template 'templates/create_archive_2s_model.rb', "db/migrate"
  end
end