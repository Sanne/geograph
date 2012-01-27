require 'java'

require File.join(Rails.root, 'lib', 'fenix', 'loader')

# Load the Cloud-TM Framework.
CLOUDTM_PATH = File.join(Rails.root, 'lib', 'cloud_tm') unless defined?(CLOUDTM_PATH)
CLOUDTM_JARS_PATH = File.join(CLOUDTM_PATH, 'jars') unless defined?(CLOUDTM_JARS_PATH)
CLOUDTM_MODELS_PATH = File.join(CLOUDTM_PATH, 'models') unless defined?(CLOUDTM_MODELS_PATH)

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
          Fenix::Loader.init(options)
        when CloudTm::Config::Framework::OGM
          Ogm::Loader.init(options)
        else
          raise "Cannot find CloudTM framework: #{options[:framework]}"
        end

      end

    end
  end

end

# TODO: make this step dynamic
# Load domain models
CloudTm::GeoObject   = Java::ItAlgoGeographDomain::GeoObject
CloudTm::Agent       = Java::ItAlgoGeographDomain::Agent
DomainRoot  = Java::ItAlgoGeographDomain::Root

Dir[File.join(CLOUDTM_PATH, '*.rb')].each{|ruby|
  next if ruby.match(/framework\.rb/)
  require ruby
}

Dir[File.join(CLOUDTM_MODELS_PATH, '*.rb')].each{|model|
  require model
}
