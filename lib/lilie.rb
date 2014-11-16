require 'lilie/analysers'
require 'lilie/jobs'
module Lilie
  Struct.new('Filter', :string, :name, :args) unless defined? Struct::Filter

  module_function

  def transform(image, filters_string)
    valid_processor_keys = Dragonfly.app(:lilie).processors.items.keys.map(&:to_s)
    filters = filters_string.split('+').map{|string| Struct::Filter.new *string.match(%r{(\w*)(?:\((.*)\))?})}.sort{ |f1,f2| f1.name <=> f2.name}
    invalids = filters.each_with_object([]) do |filter, array|
      array.push(filter.string) unless valid_processor_keys.include? filter.name
    end

    unless invalids.empty?
      errors = "#{invalids.join(', ')} - valids are: #{valid_processor_keys.join(', ')} - (dude)"
      return [errors]
    end

    transformed_image = image
    filters.each { |filter | transformed_image = transformed_image.send(filter.name.to_sym, filter.args) }
    [nil, transformed_image]
  end
end
