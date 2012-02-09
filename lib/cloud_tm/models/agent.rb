module CloudTm
  class Agent
    include Madmass::Agent::Executor
    include CloudTm::Model

    def destroy
      manager.getRoot.removeAgents(self)
    end

    class << self

      def find(oid)
        _oid = oid.to_i
        all.each do |agent|
          return agent if agent.oid == _oid
        end
        return nil
      end

      def create_with_root attrs = {}, &block
        create_without_root(attrs) do |instance|
          instance.set_root manager.getRoot
        end
      end

      alias_method_chain :create, :root

      def all
        manager.getRoot.getAgents
      end

    end
  end
end 