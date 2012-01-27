begin
  require File.join(Rails.root, 'lib', 'cloud_tm', 'framework')

  # loading the Fenix Framework
  CloudTm::Framework.init(
    :dml => 'geograph.dml',
    :conf => 'infinispan-conf.xml',
    :framework => CloudTm::Config::Framework::FENIX
  )
rescue Exception => ex
  Rails.logger.error "Cannot load Cloud-TM Framework: #{ex}"
end