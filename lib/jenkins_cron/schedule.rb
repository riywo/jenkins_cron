class JenkinsCron::Schedule
  def initialize(&block)
    @jobs = {}
    instance_eval(&block) if block_given?
  end

  def job(name, &block)
    if block_given? # initialize
      @jobs[name] = JenkinsCron::Job.new(name, &block)
    else
      @jobs[name]
    end
  end

  private

end
