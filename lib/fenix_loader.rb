require 'java'

# Load the Fenix Framework.
if Rails.env == 'production'
  # for torquebox put all fenix libraries into jboss lib folder
  #FENIX_PATH = "#{ENV['JBOSS_HOME']}/standalone/deployments/fenix.sar" unless defined?(FENIX_PATH)
  FENIX_PATH = File.join(ENV['JBOSS_HOME'], 'standalone', 'lib') unless defined?(FENIX_PATH)
else
  # for standalone version libraries are inside the application lib folder
  FENIX_PATH = File.join(Rails.root, 'lib', 'fenix') unless defined?(FENIX_PATH)
end

# require all Fenix and dependencies jars
#Dir[File.join(FENIX_PATH, '*.jar')].each{|jar|
#  puts "Loading JAR: #{jar}"
#  require jar
#}

require File.join(FENIX_PATH, 'antlr-2.7.6.jar')
require File.join(FENIX_PATH, 'jvstm.jar')
require File.join(FENIX_PATH, 'fenix-framework-r53358.jar')
require File.join(FENIX_PATH, 'geograph-domain.jar')

FENIX_CONF_PATH = File.join(FENIX_PATH, 'conf') unless defined?(FENIX_CONF_PATH)

$CLASSPATH << FENIX_PATH

# Load Fenix Framework
FenixConfig = Java::PtIstFenixframework::Config
FenixFramework = Java::PtIstFenixframework::FenixFramework

# Load the domain models
FenixGeoObject = Java::ItAlgoGeographDomain::GeoObject
FenixRoot = Java::ItAlgoGeographDomain::Root

# Load the CloudTM glue framework
CloudTmInit = Java::OrgCloudtmFramework::Init
CloudTmTxSystem = Java::OrgCloudtmFramework::TxSystem
CloudTmConfig = Java::OrgCloudtmFramework::CloudtmConfig

FenixTransactionManager = Java::OrgCloudtmFrameworkFenix::FFTxManager
IllegalWriteException = Java::PtIstFenixframeworkPstm::IllegalWriteException

class FenixTransactionManager
  def withTransaction_with_exception(&block)
    begin
      withTransaction_without_exception(block)
    rescue NativeException => e
      if e.cause.is_a?(IllegalWriteException)
        setReadOnly(false)
        withTransaction_without_exception(block)
      else
        raise e.cause
      end
    end
  end

  alias_method_chain(:withTransaction, :exception)
end


# In order to bypass the use of the constructor with closure, that causes problems
# in the jruby binding.
# Here we open the Fenix Config class and we define a method that permits to
# valorize the same protected variables managed by the standard constructor.
class FenixConfig
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
class FenixLoader
  # Load the Fenix Framework.
  # Options:
  # => dml: the dml file name
  # => conf: the configuration file name
  # => root: the root class
  def self.load(options)
    config = FenixConfig.new
    config.init(
      :domainModelPath => File.join(FENIX_CONF_PATH, options[:dml]),
      :dbAlias => File.join(FENIX_CONF_PATH, options[:conf]),
      :rootClass => FenixRoot.java_class,
      :repositoryType => FenixConfig::RepositoryType::INFINISPAN
    )

    CloudTmInit.initializeTxSystem(config, CloudTmConfig::Framework::FENIX)
    CloudTmTransactionManager.manager = CloudTmTxSystem.getManager
  end
end
