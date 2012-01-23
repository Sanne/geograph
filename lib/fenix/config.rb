module Fenix

  # In order to bypass the use of the constructor with closure, that causes problems
  # in the jruby binding.
  # Here we open the Fenix Config class and we define a method that permits to
  # valorize the same protected variables managed by the standard constructor.
  class Config
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
end