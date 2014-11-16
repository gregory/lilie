require 'lilie/analysers'
require 'lilie/jobs'
module Lilie
  Struct.new('Filter', :name, :args) unless defined? Struct::Filter
  #TODO: write spec for this
  PARAM_SPLIT = %r{(\w+)(?:\(([\w|<|#|+|-|!]+)\))?} #thumb(400x200+ne),to_p(foo-1),to_c

  module_function

  def processors
    Dragonfly.app(:lilie).processors.items
  end

  def process!(process, content, *args)
    processors[process].call(content, *args)
  end

  def transform(image, filters_string)
    valid_processor_keys = Dragonfly.app(:lilie).processors.items.keys.map(&:to_s)
    filters = filters_string.scan(PARAM_SPLIT).map{|split| Struct::Filter.new *split}.sort{ |f1,f2| f1.name <=> f2.name}
    invalids = filters.each_with_object([]) do |filter, array|
      array.push(filter.name) unless valid_processor_keys.include? filter.name
    end

    unless invalids.empty?
      errors = "#{invalids.join(', ')} - valids are: #{valid_processor_keys.join(', ')} - (dude)"
      return [errors]
    end

    transformed_image = image
    filters.each do |filter|
      meth = filter.name.to_sym
      transformed_image = transformed_image.send(meth, filter.args) if transformed_image.respond_to? meth
    end
    [nil, transformed_image]
  end
end
