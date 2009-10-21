require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'active_record_connectionless'

class GeocodableModel < ActiveRecord::Base
  emulate_attribute :lat, :lng
  is_geocodable
end

class GeocodableModelWithoutGeocode < ActiveRecord::Base
  emulate_attribute :lat, :lng
  is_geocodable :geocode => false
end

class GeocodableModelWithRequire < ActiveRecord::Base
  emulate_attribute :lat, :lng
  is_geocodable :require => true
end


describe GeocodableModel do

  before(:each) do
    @geocodable_model = GeocodableModel.new
    @geocoder = mock(Geokit::Geocoders::MultiGeocoder)
    @geo = mock(Geokit::GeoLoc)
  end

  it 'geo should return geocoded complete_address from multigeocoder' do
    @geocoder.should_receive(:geocode).with(:downcase_complete_address).and_return(:geo)
    @geocodable_model.should_receive(:geocoder).and_return(@geocoder)
    @geocodable_model.should_receive(:downcase_complete_address).and_return(:downcase_complete_address)
    @geocodable_model.geo.should == :geo
  end

  describe 'geocoding_occured?' do
    before(:each) do
      @geocodable_model.should_receive(:geocoder).and_return(@geocoder)
      @geocodable_model.stub!(:downcase_complete_address)
    end

    it 'should be true when geocoding occured' do
      @geocoder.should_receive(:geocode).and_return(:geo)
      @geocodable_model.geo
      @geocodable_model.geocoding_occured?.should be_true
    end

    it 'should be false when geocoding not occured' do
      @geocoder.should_receive(:geocode).and_return(nil)
      @geocodable_model.geo
      @geocodable_model.geocoding_occured?.should be_false
    end
  end

  describe 'geocoding_successful?' do
    it 'should be true when geocoding occured and was successful' do
      @geocodable_model.should_receive(:geocoding_occured?).and_return(true)
      @geocodable_model.should_receive(:geo).and_return(@geo)
      @geo.should_receive(:success).and_return(true)
      @geocodable_model.geocoding_successful?.should be_true
    end

    it 'should be false when geocoding not occured' do
      @geocodable_model.should_receive(:geocoding_occured?).and_return(false)
      @geocodable_model.geocoding_successful?.should be_false
    end

    it 'should be false when geocoding occured but was not successful' do
      @geocodable_model.should_receive(:geocoding_occured?).and_return(true)
      @geocodable_model.should_receive(:geo).and_return(@geo)
      @geo.should_receive(:success).and_return(false)
      @geocodable_model.geocoding_successful?.should be_false
    end
  end

  describe 'lat?' do
    it 'should be true when lat is not nil' do
      @geocodable_model.should_receive(:lat).and_return(47)
      @geocodable_model.lat?.should be_true
    end

    it 'should be false when lat is nil' do
      @geocodable_model.should_receive(:lat).and_return(nil)
      @geocodable_model.lat?.should be_false
    end
  end

  describe 'lng?' do
    it 'should be true when lng is not nil' do
      @geocodable_model.should_receive(:lng).and_return(47)
      @geocodable_model.lng?.should be_true
    end

    it 'should be false when lng is nil' do
      @geocodable_model.should_receive(:lng).and_return(nil)
      @geocodable_model.lng?.should be_false
    end
  end

  describe 'geocoded?' do
    it 'should be true when lat and lng are ok' do
      @geocodable_model.should_receive(:lat?).and_return(true)
      @geocodable_model.should_receive(:lng?).and_return(true)
      @geocodable_model.geocoded?.should be_true
    end

    it 'should be false when lng is not ok' do
      @geocodable_model.should_receive(:lat?).and_return(true)
      @geocodable_model.should_receive(:lng?).and_return(false)
      @geocodable_model.geocoded?.should be_false
    end

    it 'should be false when lat is not ok' do
      @geocodable_model.should_receive(:lat?).and_return(false)
      @geocodable_model.geocoded?.should be_false
    end
  end

  it 'geocoder should return Geokit::Geocoders::MultiGeocoder' do
    @geocodable_model.geocoder.should == Geokit::Geocoders::MultiGeocoder
  end

  describe 'geocode_complete_address' do
    it 'should do nothing when we prevent geocoding' do
      @geocodable_model.should_receive(:geocode?).and_return(false)
      @geocodable_model.geocode_complete_address.should be_nil
    end

    it 'should do nothing when complete address not ready for geocoding' do
      @geocodable_model.should_receive(:geocode?).and_return(true)
      @geocodable_model.should_receive(:geocode_complete_address?).and_return(false)
      @geocodable_model.geocode_complete_address.should be_nil
    end

    it 'should set_geocode_data when geocoding was successful' do
      @geocodable_model.should_receive(:geocode?).and_return(true)
      @geocodable_model.should_receive(:geocode_complete_address?).and_return(true)
      @geocodable_model.should_receive(:runned_geocoding_successful?).and_return(true)
      @geocodable_model.should_receive(:set_geocode_data).and_return(true)
      @geocodable_model.geocode_complete_address.should be_true
    end

    it 'should set error for complete address when geocoding was not successful' do
      @geocodable_model.should_receive(:geocode?).and_return(true)
      @geocodable_model.should_receive(:geocode_complete_address?).and_return(true)
      @geocodable_model.should_receive(:runned_geocoding_successful?).and_return(false)
      @geocodable_model.should_receive(:geocode_complete_address_error)
      @geocodable_model.geocode_complete_address.should be_false
    end
  end

  describe 'set_geocode_data' do
    it 'should set data from geo and return true' do
      @geo.should_receive(:lat).and_return(84)
      @geo.should_receive(:lng).and_return(72)
      @geocodable_model.should_receive(:geo).twice.and_return(@geo)
      @geocodable_model.set_geocode_data.should be_true
      @geocodable_model.lat.should == 84
      @geocodable_model.lng.should == 72
    end

    it 'should return false when not both lat and lng was set' do
      @geo.should_receive(:lat).and_return(84)
      @geo.should_receive(:lng).and_return(nil)
      @geocodable_model.should_receive(:geo).twice.and_return(@geo)
      @geocodable_model.set_geocode_data.should be_false
    end
  end

  it 'geocode_complete_address_error should add error to complete_address' do
    @geocodable_model.should_receive(:geocode_complete_address_error_messsage).and_return(:geocode_complete_address_error_messsage)
    errors = mock(ActiveRecord::Errors)
    errors.should_receive(:add).with(:complete_address, :geocode_complete_address_error_messsage)
    @geocodable_model.should_receive(:errors).and_return(errors)
    @geocodable_model.geocode_complete_address_error
  end

  it 'geocode_complete_address_error_messsage should have proper message' do
    @geocodable_model.should_receive(:complete_address).and_return('complete_address')
    @geocodable_model.geocode_complete_address_error_messsage.should == "Cannot geocode complete address: complete_address"
  end

  describe 'geocode_complete_address?' do
    it 'should be true when complete_address changed and it is not blank' do
      @geocodable_model.should_receive(:complete_address_changed?).and_return(true)
      @geocodable_model.should_receive(:complete_address?).and_return(true)
      @geocodable_model.geocode_complete_address?.should be_true
    end

    it 'should be false when complete_address changed but it is blank' do
      @geocodable_model.should_receive(:complete_address_changed?).and_return(true)
      @geocodable_model.should_receive(:complete_address?).and_return(false)
      @geocodable_model.geocode_complete_address?.should be_false
    end

    it 'should be false when complete_address not changed' do
      @geocodable_model.should_receive(:complete_address_changed?).and_return(false)
      @geocodable_model.geocode_complete_address?.should be_false
    end
  end

  describe 'complete_address?' do
    it 'should be true when complete_address is not blank' do
      @geocodable_model.should_receive(:complete_address).and_return('complete address')
      @geocodable_model.complete_address?.should be_true
    end

    it 'should be false when complete_address is blank' do
      @geocodable_model.should_receive(:complete_address).and_return('')
      @geocodable_model.complete_address?.should be_false
    end
  end

  it 'geocode? should be true unless You want to disable geocoding' do
    @geocodable_model.geocode?.should be_true
  end

  it 'should validate geocode_complete_address' do
    @geocodable_model.should_receive(:geocode_complete_address).and_return(true)
    @geocodable_model.should be_valid
  end

  it 'should provide geocoded named_scope' do
    GeocodableModel.should_receive(:find).and_return([])
    GeocodableModel.geocoded.should == []
  end

end


describe GeocodableModelWithoutGeocode do

  it 'should not validate geocode_complete_address' do
    geocodable_model = GeocodableModelWithoutGeocode.new
    geocodable_model.should_not_receive(:geocode_complete_address)
    geocodable_model.should be_valid
  end

end


describe GeocodableModelWithRequire do

  before(:each) do
    @geocodable_model = GeocodableModelWithRequire.new(:lat => 84, :lng => 72)
    @geocodable_model.stub!(:geocode_complete_address).and_return(true)
  end

  it 'should be valid with all ok' do
    @geocodable_model.should be_valid
  end

  it 'should not be valid with empty lat' do
    @geocodable_model.lat = nil
    @geocodable_model.should_not be_valid
  end

  it 'should not be valid with empty lng' do
    @geocodable_model.lng = nil
    @geocodable_model.should_not be_valid
  end

  it 'should not be valid with not numeric lat' do
    @geocodable_model.lat = 'a'
    @geocodable_model.should_not be_valid
  end

  it 'should not be valid with not numeric lng' do
    @geocodable_model.lng = 'a'
    @geocodable_model.should_not be_valid
  end

  it 'should not be valid when geocode_complete_address was not successful' do
    @geocodable_model.should_receive(:geocode_complete_address).and_return(false)
    @geocodable_model.should_not be_valid
  end

end
