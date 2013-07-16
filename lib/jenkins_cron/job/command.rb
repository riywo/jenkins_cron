class JenkinsCron::Job::Command
  def initialize(command, opts = {})
    @command = command
    @opts = {}
    @opts[:env]  = opts[:env]
    @opts[:user] = opts[:user]
    @opts[:cwd]  = opts[:cwd]
  end

  def shell_command
    script = export_env
    script += "#{sh} -c '#{command}'\n"
  end

  private

  def export_env
    env = @opts[:env] || {}
    export = ""
    env.each do |key, value|
      export += "export #{key}=#{value}\n"
    end
    export
  end

  def sh
    if @opts[:user]
      "su - #{@opts[:user]} -l"
    else
      "sh"
    end
  end

  def cd
    if @opts[:cwd]
      "cd #{@opts[:cwd]} && "
    else
      ""
    end
  end

  def command
    "#{cd}#{@command}"
  end
end
