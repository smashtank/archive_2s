require "archive_2s/model"
module Archive2s
  DEFAULT_ARGUMENTS = {
      :method_name => :to_s,
      :include_by_default => false
  }
  module ClassMethods
    def archive_2s(args = {})
      # don't allow multiple calls
      return if self.included_modules.include?(Archive2s::InstanceMethods)

      include InstanceMethods
      extend  ClassMethods

      singleton = class << self; self; end
      singleton.module_eval do
        define_method(:archive_2s_args) do
          @archive_2s_args
        end
        define_method(:archive_2s_args=) do |value|
          @archive_2s_args = value
        end
      end
      self.archive_2s_args = Archive2s::DEFAULT_ARGUMENTS.merge(args)

      #TODO: make some proxy magic so if one calls a relationship if can search the archive too
      if self.archive_2s_args[:include_by_default]
        singleton.module_eval do
          def find(*args)
            super rescue self.find_with_archived(args)
          end
        end
      end
    end
  end

  module InstanceMethods
    def self.included(base)
      base.class_eval do
        alias_method_chain :destroy, :archive
      end
    end

    # wrap it all up in a transaction
    def destroy_with_archive
      self.class.transaction do
        archived = ::Archive2s::Model.new(:model => self, :archived_value => self.send(self.class.archive_2s_args[:method_name]), :archived_at => Time.now)
        archived.save!
        destroy_without_archive
      end
    end
  end

  module ClassMethods
    def find_archived(*ids)
      ids.flatten!
      #don't use scopes so it is rails 2 and 3 compliant
      archived_models = ::Archive2s::Model.all(:conditions => ["model_type = ? AND model_id IN (#{(['?'] * ids.length).join(',')})", self.to_s, *ids]).collect(&:model)

      if archived_models.length != ids.length
        if ids.length == 1
          raise ActiveRecord::RecordNotFound, "Couldn't find Archived #{self.to_s} with ID=#{ids.first}"
        else
          raise ActiveRecord::RecordNotFound, "Couldn't find all Archived #{self.to_s.pluralize} with IDs (#{ids.join(',')})"
        end
      end

      #TODO: use wants
      if archived_models.length > 1
        archived_models
      else
        archived_models.first
      end
    end

    def find_with_archived(*args)
      begin
        #might as well try AR first
        super.find(args)
      rescue Exception => e
        #can only fetch archived by ids so don't attempt if there were extra args
        if args.flatten! && args.length != args.select{|i| i == i.to_i}.length
          raise e
        else
          items = self.all(:conditions => ["id IN (#{(['?'] * args.length).join(',')})", *args])
          items += [self.find_archived(*args - items.collect(&:id))].flatten
          if args.length == items.length
            items
          else
            raise e
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :extend, Archive2s::ClassMethods
