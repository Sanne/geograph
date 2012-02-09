module Fenix
  class RelationList
    def to_json
      map(&:attributes_to_hash).to_json
    end
  end
end