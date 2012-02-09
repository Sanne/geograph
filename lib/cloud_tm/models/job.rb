module CloudTm
  class Job
    include CloudTm::Model

    def destroy
      manager.getRoot.removeJobs(self)
    end

    def has_properties?(options)
      options.each do |prop, value|
        return false if send(prop) != value
      end
      true
    end

    class << self

      def find(oid)
        _oid = oid.to_i
        all.each do |job|
          return job if job.oid == _oid
        end
        return nil
      end

      def where(options = {})
        jobs = []
        all.each do |job|
          jobs << job if job.has_properties?(options)
        end
        return jobs
      end

      def create_with_root attrs = {}, &block
        create_without_root(attrs) do |instance|
          instance.set_root manager.getRoot
        end
      end

      alias_method_chain :create, :root

      def all
        manager.getRoot.getJobs
      end

    end
  end
end 