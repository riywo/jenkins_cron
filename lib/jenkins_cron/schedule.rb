class JenkinsCron::Schedule
  attr_reader :name

  def initialize(name, &block)
    @name = name
    @jobs = {}
    instance_eval(&block) if block_given?
  end

  def job(job_name, &block)
    if block_given? # initialize
      @jobs[job_name] = JenkinsCron::Job.new(job_name, &block)
    else
      @jobs[job_name]
    end
  end

  private

end
