class HomeController < ApplicationController
  before_filter :authenticate_agent

  def index
    CloudTm::TxSystem.getManager.withTransaction do
      @geo_objects = CloudTm::GeoObject.all.to_json
    end
  end

  def map
    CloudTm::TxSystem.getManager.withTransaction do
      @geo_objects = CloudTm::GeoObject.all.to_json
    end
  end
end
