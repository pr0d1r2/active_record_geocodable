require 'geokit'

module ActiveRecord
  module Geocodable
    module Model

      def geo
        @geo ||= geocoder.geocode(complete_address)
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

      def geocoded?
        lat? && lng?
      end

      def geocoder
        Geokit::Geocoders::MultiGeocoder
      end

    end
  end
end
