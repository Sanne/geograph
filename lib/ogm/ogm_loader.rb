require 'java'

# Load the Fenix Framework.
if Rails.env == 'none'
  # for torquebox put all fenix libraries into jboss lib folder
  #FENIX_PATH = "#{ENV['JBOSS_HOME']}/standalone/deployments/fenix.sar" unless defined?(FENIX_PATH)
  OGM_PATH = "#{ENV['JBOSS_HOME']}/standalone/lib" unless defined?(FENIX_PATH)
else
  # for standalone version libraries are inside the application lib folder
  OGM_PATH = "#{Rails.root}/lib/ogm" unless defined?(FENIX_PATH)


end
# require all Ogm and dependencies jars
#Dir[File.join(OGM_PATH, '*.jar')].each{|jar|
#  puts "Loading JAR: #{jar}"
#  require jar
#}

require File.join(OGM_PATH, 'geograph-domain-ogm.jar')

#FENIX_CONF_PATH = "#{Rails.root}/lib/fenix/conf" unless defined?(FENIX_CONF_PATH)

$CLASSPATH << OGM_PATH

# shortcut to some Fenix classes
OgmConfig = Java::PtIstFenixframework::Config

# Load the domain models
OgmGeoObject = Java::ItAlgoGeographDomain::GeoObject
OgmRoot = Java::ItAlgoGeographDomain::Root
OgmInit = Java::ItAlgoGeograph::Init
OgmTxSystem = Java::ItAlgoGeograph::TxSystem


# In order to bypass the use of the constructor with closure, that causes problems
# in the jruby binding.
# Here we open the Fenix Config class and we define a method that permits to
# valorize the same protected variables managed by the standard constructor.
class OgmConfig
  # Accepts an hash of params, keys are instance variables of FenixConfig class
  # and values are used to valorize these variables.
  def init params
    params.each do |name, value|
      set_param(name, value)
    end
  end

  private

  # Sets an instance variable value.
  def set_param(name, value)
    # Jruby doesn't offer accessors for the protected variables.
    field = self.java_class.declared_field name
    field.accessible = true
    field.set_value Java.ruby_to_java(self), Java.ruby_to_java(value)
  end
end

class CloudTmTransactionManager
  cattr_accessor :manager
end

# This is the Fenix Framework loader. It provides a simple way to
# run the framework initialization process.
class OgmLoader
  # Load the Fenix Framework.
  # Options:
  # => dml: the dml file name
  # => conf: the configuration file name
  # => root: the root class
  def self.load(options)
    config = OgmConfig.new
    config.init(
      :domainModelPath => options[:dml],
      :dbAlias => options[:conf],
      :rootClass => OgmRoot.java_class,
      :repositoryType => OgmConfig::RepositoryType::INFINISPAN
    )
 
    OgmInit.initializeTxSystem(config)
    CloudTmTransactionManager.manager = OgmTxSystem.getManager
  end
end
