class JenkinsCron::Job::Command
  def initialize(command, opts = {})
    @command = command
    @opts    = opts
  end

  def shell_command
    script  = export_env
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
      #TODO use each user's shell
      "sudo -u #{@opts[:user]} -H bash -l"
    else
      "bash"
    end
  end

  def cd
    if @opts[:cwd]
      "cd #{@opts[:cwd].shellescape} && "
    else
      ""
    end
  end

  def command
    "#{cd}#{@command}"
  end
end
