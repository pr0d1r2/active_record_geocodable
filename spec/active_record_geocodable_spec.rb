require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'active_record_connectionless'

class GeocodableModel < ActiveRecord::Base
  is_geocodable
end


describe GeocodableModel do

  before(:each) do
    @geocodable_model = GeocodableModel.new
    @geocoder = mock(Geokit::Geocoders::MultiGeocoder)
  end

  it 'geo should return geocoded complete_address from multigeocoder' do
    @geocoder.should_receive(:geocode).with(:complete_address).and_return(:geo)
    @geocodable_model.should_receive(:geocoder).and_return(@geocoder)
    @geocodable_model.should_receive(:complete_address).and_return(:complete_address)
    @geocodable_model.geo.should == :geo
  end

  describe 'geocoding_occured?' do
    it 'should be true when geocoding occured' do
      @geocoder.should_receive(:geocode).and_return(:geo)
      @geocodable_model.should_receive(:geocoder).and_return(@geocoder)
      @geocodable_model.stub!(:complete_address)
      @geocodable_model.geo
      @geocodable_model.geocoding_occured?.should be_true
    end

    it 'should be false when geocoding not occured' do
      @geocoder.should_receive(:geocode).and_return(nil)
      @geocodable_model.should_receive(:geocoder).and_return(@geocoder)
      @geocodable_model.stub!(:complete_address)
      @geocodable_model.geo
      @geocodable_model.geocoding_occured?.should be_false
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

end
