module ActsAsTaggableOn
  module Taggable
    def taggable?
      false
    end

    ##
    # This is an alias for calling <tt>acts_as_taggable_on :tags</tt>.
    #
    # Example:
    #   class Book < ActiveRecord::Base
    #     acts_as_taggable
    #   end
    def acts_as_taggable
      acts_as_taggable_on :tags
    end

    def base_model_name
      model_name
    end

    def base_model_class
      model
    end


    ##
    # Make a model taggable on specified contexts.
    #
    # @param [Array] tag_types An array of taggable contexts
    #
    # Example:
    #   class User < ActiveRecord::Base
    #     acts_as_taggable_on :languages, :skills
    #   end
    def acts_as_taggable_on(*tag_types)
      tag_types = tag_types.to_a.flatten.compact.map(&:to_sym)

      if taggable?
          self.tag_types = (self.tag_types + tag_types).uniq
      else
          class_attribute :tag_types
          self.tag_types = tag_types

        class_eval do
          has_many :taggings, :as => :taggable, :dependent => :destroy, :include => :tag, :class_name => "ActsAsTaggableOn::Tagging"
          has_many :base_tags, :through => :taggings, :source => :tag, :class_name => "ActsAsTaggableOn::Tag"

          def self.taggable?
            true
          end

          include ActsAsTaggableOn::Utils
          include ActsAsTaggableOn::Taggable::Core
          include ActsAsTaggableOn::Taggable::Collection
          include ActsAsTaggableOn::Taggable::Cache
          include ActsAsTaggableOn::Taggable::Ownership
          include ActsAsTaggableOn::Taggable::Related
          include ActsAsTaggableOn::Taggable::Dirty
        end
      end
    end
  end
end
