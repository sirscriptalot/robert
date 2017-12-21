class Robert
  VERSION = '0.1.0'

  class ValidationError < StandardError; end

  class << self
    def build(klass, args = {})
      new(args).build(klass)
    end

    def build!(klass, args = {})
      new(args).build!(klass)
    end
  end

  attr_reader :attributes, :errors

  def initialize(args = {})
    args.each do |key, value|
      writer = :"#{key}="

      if respond_to?(writer)
        send(writer, value)
      end
    end

    reset
  end

  def default_attributes
    {}
  end

  def default_errors
    Hash.new { |h, k| h[k] = [] }
  end

  def build(klass)
    valid? && klass.new(attributes)
  end

  def build!(klass)
    build(klass) || raise(ValidationError, errors)
  end

  def valid?
    reset

    validate

    errors.empty?
  end

  private

  def add_attribute(key, value)
    attributes[key] = clean(value) unless errors.has_key?(key)
  end

  def add_error(key, error)
    attributes.delete(key)

    errors[key] << error
  end

  def clean(value)
    value
  end

  def error(key, error, &condition)
    value = send(key)

    if value.instance_eval &condition
      add_error(key, error)

      true
    else
      add_attribute(key, value)

      false
    end
  end

  def reset
    @attributes = default_attributes
    @errors = default_errors
  end

  def validate
    raise NotImplementedError
  end
end
