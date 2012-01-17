class HomeController < ApplicationController
  before_filter :authenticate_agent

  def index
    @geo_objects = GeoObject.all
  end

  def map
    @geo_objects = GeoObject.all
  end
end
