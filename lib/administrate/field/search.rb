require "administrate/field/associative"
require "administrate/page/collection"

module Administrate
  module Field
    class Search < Associative
      DEFAULT_LIMIT = 5
      VERSION = "0.0.1"

      class Engine < ::Rails::Engine
      end

      def self.permitted_attribute(attribute)
        { "#{attribute.to_s.singularize}_ids".to_sym => [] }
      end

      def associated_collection
        Administrate::Page::Collection.new(associated_dashboard)
      end

      def attribute_key
        permitted_attribute.keys.first
      end

      def associated_resource_options
        candidate_resources.map do |resource|
          [display_candidate_resource(resource), resource.id]
        end
      end

      def selected_options
        data && data.map(&:id)
      end

      def limit
        options.fetch(:limit, DEFAULT_LIMIT)
      end

      def permitted_attribute
        self.class.permitted_attribute(attribute)
      end

      def resources
        data.limit(limit)
      end

      def more_than_limit?
        data.count(:all) > limit
      end

      private

      def candidate_resources
        associated_class.all
      end

      def display_candidate_resource(resource)
        associated_dashboard.display_resource(resource)
      end
    end
  end
end