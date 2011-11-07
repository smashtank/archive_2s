module Archive2s
  class Model < ActiveRecord::Base
    #TODO: drop the id column and use the index
    set_table_name :archived_to_s
    belongs_to :model, :polymorphic => true

    def model
      archived_model = model_class.new()
      archived_model.id = self.model_id
      #can't use self in the instance_eval/define method so make a local variable first
      return_value = self.archived_value

      archived_model.instance_eval do
        singleton = class << self; self; end
        singleton.send(:define_method, self.class.archive_2s_args[:method_name]) do
          return_value
        end
      end
      
      archived_model.readonly!
      archived_model
    end

    def model_class
      @model_class ||= eval(self.model_type.classify)
    end
  end
end