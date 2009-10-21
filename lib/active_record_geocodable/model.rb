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

      def geocoding_successful?
        geocoding_occured? && geo.success
      end

      def lat?
        !lat.blank?
      end

      def lng?
        !lng.blank?
      end

      def geocoded?
        lat? && lng?
      end

      def geocoder
        Geokit::Geocoders::MultiGeocoder
      end

      def geocode_complete_address
        if geocode? && geocode_complete_address?
          if runned_geocoding_successful?
            set_geocode_data && true
          else
            geocode_complete_address_error
            false
          end
        end
      end

      def runned_geocoding_successful?
        geo && geocoding_successful?
      end

      def set_geocode_data
        !(self.lat = geo.lat).nil? && !(self.lng = geo.lng).nil?
      end

      def geocode_complete_address_error
        errors.add(:complete_address, geocode_complete_address_error_messsage)
      end

      def geocode_complete_address_error_messsage
        "Cannot geocode complete address: #{complete_address}"
      end

      def geocode_complete_address?
        complete_address_changed? && complete_address?
      end

      def complete_address?
        !complete_address.blank?
      end

      def geocode?
        true
      end

    end
  end
end
