require 'geokit'

module ActiveRecord
  module Geocodable
    module Model

      def geo
        @geo ||= Geokit::Geocoders::MultiGeocoder.geocode(address)
      end

      def geocoding_occured?
        !@geo.nil?
      end

      def lat?
        !lat.nil?
      end

      def lng?
        !lng.nil?
      end

      def success?
        lat? && lng?
      end

    end
  end
end
