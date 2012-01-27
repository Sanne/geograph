# Load the Fenix Framework.
FENIX_PATH = File.join(Rails.root, 'lib', 'fenix') unless defined?(FENIX_PATH)
FENIX_JARS_PATH = File.join(FENIX_PATH, 'jars') unless defined?(FENIX_JARS_PATH)
FENIX_CONF_PATH = File.join(FENIX_PATH, 'conf') unless defined?(FENIX_CONF_PATH)

# Require all Fenix and dependencies jars
Dir[File.join(FENIX_JARS_PATH, '*.jar')].each{|jar|
  require jar
}

# Add jars path to the class path
$CLASSPATH << FENIX_JARS_PATH
$CLASSPATH << FENIX_CONF_PATH


module Fenix
  Config                  = Java::PtIstFenixframework::Config
  RelationList            = Java::PtIstFenixframeworkPstm::RelationList
  FenixTransactionManager = Java::OrgCloudtmFrameworkFenix::FFTxManager
  
  # This is the Fenix Framework loader. It provides a simple way to
  # run the framework initialization process.
  class Loader
    class << self
      # Load and initialize the Fenix Framework.
      # Options:
      # => dml: the dml file name
      # => conf: the configuration file name
      # => root: the root class
      def init(options)
        config = Fenix::Config.new
        config.init(
          :domainModelPath => File.join(FENIX_CONF_PATH, options[:dml]),
          :dbAlias => File.join(FENIX_CONF_PATH, options[:conf]),
          :rootClass => options[:root] || DomainRoot.java_class,
          :repositoryType => Fenix::Config::RepositoryType::INFINISPAN
        )

        CloudTm::Init.initializeTxSystem(config, CloudTm::Config::Framework::FENIX)
      end
    end
  end
end

Dir[File.join(FENIX_PATH, '*.rb')].each{|ruby|
  next if ruby.match(/loader\.rb/)
  require ruby
}

