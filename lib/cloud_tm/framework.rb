require 'java'

require File.join(Rails.root, 'lib', 'fenix', 'loader')

# Load the Cloud-TM Framework.
CLOUDTM_JARS_PATH = File.join(Rails.root, 'lib', 'cloud_tm')
# Require all Cloud-TM and dependencies jars
Dir[File.join(CLOUDTM_JARS_PATH, '*.jar')].each{|jar|
  require jar
}
# Add jars path to the class path
$CLASSPATH << CLOUDTM_JARS_PATH

module CloudTm

  Init     = Java::OrgCloudtmFramework::Init
  TxSystem = Java::OrgCloudtmFramework::TxSystem
  Config   = Java::OrgCloudtmFramework::CloudtmConfig

  class Framework
    class << self

      def init(options)
        case options[:framework]
        when CloudTm::Config::Framework::FENIX
#          require File.join(Rails.root, 'lib', 'fenix', 'loader')
          Fenix::Loader.init(options)
        when CloudTm::Config::Framework::OGM
#          require File.join(Rails.root, 'lib', 'ogm', 'loader')
          Ogm::Loader.init(options)
        else
          raise "Cannot find CloudTM framework: #{options[:framework]}"
        end

      end

    end
  end

end

