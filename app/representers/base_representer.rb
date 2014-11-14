require 'roar/decorator'

class BaseRepresenter < Roar::Decorator
  #include Roar::Representer::JSON
  #include Roar::Representer::JSON::CollectionJSON

  #version '1.0'

  #def to_hash(options={})
    #super default_options.merge(options)
  #end

  #def default_options
    #{
      #api_endpoint: CONFIG.api_endpoint
    #}
  #end

  #def represent_class; end

  #def method_missing(method_name, *args, &block)
    #return self.represented.send(method_name, *args, &block) if self.represented.respond_to?(method_name)
    #super
  #end
end
