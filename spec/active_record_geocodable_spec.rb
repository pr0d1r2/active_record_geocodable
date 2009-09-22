require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'active_record_connectionless'

class GeocodableModel < ActiveRecord::Base
  is_geocodable
end


describe GeocodableModel do

  before(:each) do
    @geocodable_model = GeocodableModel.new
  end

  it 'geo should return geocoded address from multigeocoder' do
    @geocodable_model.should_receive(:address).and_return(:address)
    Geokit::Geocoders::MultiGeocoder.should_receive(:geocode).with(:address).and_return(:geo)
    @geocodable_model.geo.should == :geo
  end

  describe 'geocoding_occured?' do
    it 'should be true when geocoding occured' do
      Geokit::Geocoders::MultiGeocoder.should_receive(:geocode).and_return(:geo)
      @geocodable_model.stub!(:address)
      @geocodable_model.geo
      @geocodable_model.geocoding_occured?.should be_true
    end

    it 'should be false when geocoding not occured' do
      Geokit::Geocoders::MultiGeocoder.should_receive(:geocode).and_return(nil)
      @geocodable_model.stub!(:address)
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

end
