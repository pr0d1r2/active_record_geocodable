module ActiveRecord
  module Geocodable
    module Base

      def is_geocodable(options = {})
        include ActiveRecord::Geocodable::Model
        options = {:geocode => true}.merge(options)
        if options[:require]
          validates_presence_of :lat
          validates_presence_of :lng
          validates_numericality_of :lat
          validates_numericality_of :lng
          options[:geocode] = true
        end
        before_validation :geocode_complete_address if options[:geocode]
        named_scope :geocoded, :conditions => "#{table_name}.lat IS NOT NULL AND #{table_name}.lng IS NOT NULL"
      end

    end
  end
end

ActiveRecord::Base.extend(ActiveRecord::Geocodable::Base)
