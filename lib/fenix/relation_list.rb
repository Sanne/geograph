module Fenix
  class RelationList
    def to_json
      map(&:attributes_to_hash).to_json
      #com.google.gson.Gson.new.toJson(self)
    end
  end
end