class JenkinsCron::Job
  attr_reader :name, :params

  def initialize(name, &block)
    @name = name
    @params = {}
    instance_eval(&block) if block_given?
    @params.freeze
  end

  private

  def method_missing(key, value)
    @params[key] = value
  end
end
