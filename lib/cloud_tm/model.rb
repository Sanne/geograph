module CloudTm
  module Model

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def manager
        CloudTm::TxSystem.getManager
      end

      def create attrs = {}, &block
        instance = new
        attrs.each do |attr, value|
          instance.send("#{attr}=", value)
        end
        manager.save instance
        block.call(instance) if block_given?
        instance
      end
    
    end
    
    def update_attributes attrs = {}
      attrs.each do |property, value|
        send("#{property}=", value)
      end
    end

    private

    def manager
      CloudTm::TxSystem.getManager
    end
  end
end
