class Archive2sModelGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'templates/create_archive_2s_model.rb', "db/migrate"
    end
  end
end