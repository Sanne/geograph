module CloudTm
  module Transaction

    class CloudTmAdapter
      class << self
        def transaction &block
          CloudTm::TxSystem.getManager.withTransaction do
            block.call
          end
        end

        def rescues
          {
#            Exception => Proc.new {
#              sleep(rand(1)/4.0)
#              retry
#              return
#            }
          }
        end

      end
    end

  end
end