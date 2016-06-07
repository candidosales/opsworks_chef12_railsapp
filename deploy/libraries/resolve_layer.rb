class AttributeSearch
  extend Chef::DSL::DataQuery
end

module OpsWorks
  module ResolveLayer
    def self.resolve_current_layer(layer_data_bag)
      instance = AttributeSearch.search('aws_opsworks_instance', 'self:true').first
      layer_data_bag.detect do |layer|
        layer[:layer_id] == instance[:layer_ids].first
      end
    end
  end
end
