class JenkinsCron::Job
  attr_reader :name, :params

  def initialize(schedule, name, &block)
    @schedule = schedule
    @name = name
    @params = { name: "#{@schedule.name}-#{@name}" }
    instance_eval(&block)
    @params.freeze
  end

  private

  def command(command, opts = {})
    cmd = JenkinsCron::Job::Command.new(command, opts)
    @params[:shell_command] = cmd.shell_command
  end

  def timer(opts = {}, &block)
    timer = JenkinsCron::Job::Timer.new(opts, &block)
    if @params[:timer].nil?
      @params[:timer] = timer.to_s
    else
      @params[:timer] += "\n" + timer.to_s
    end
  end

  def options(key, value)
    @params[key] = value
  end
end
