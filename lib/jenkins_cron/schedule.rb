class JenkinsCron::Schedule
  attr_reader :name

  def initialize(name, &block)
    @name = name
    @jobs = {}
    instance_eval(&block) if block_given?
  end

  def self.load(name, file_path)
    block = File.read(file_path)
    new(name) { eval(block) }
  end

  def each_jobs
    @jobs.each do |name, job|
      yield job
    end
  end

  def job(job_name, &block)
    if block_given? # initialize
      @jobs[job_name] = JenkinsCron::Job.new(self, job_name, &block)
    else
      @jobs[job_name]
    end
  end

  private

end
