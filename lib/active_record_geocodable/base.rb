module ActiveRecord
  module Geocodable
    module Base

      def is_geocodable
        include ActiveRecord::Geocodable::Model
      end

    end
  end
end

ActiveRecord::Base.extend(ActiveRecord::Geocodable::Base)
