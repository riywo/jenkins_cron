class JenkinsCron::Job
  attr_reader :name, :params

  def initialize(name, &block)
    @name = name
    @params = { name: @name.to_s }
    instance_eval(&block)
    @params.freeze
  end

  private

  def method_missing(key, value)
    @params[key] = value
  end
end
