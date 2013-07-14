require "thor"
require "yaml"
require "jenkins_api_client"

class JenkinsCron::CLI < Thor
  class_option :config, type: :string, aliases: "-c", default: "config/jenkins.yml", desc: "Jenkins config file"

  desc "update NAME", "Update Jenkins using config/schedule/NAME.rb"
  def update(name)
    schedule = JenkinsCron::Schedule.load(name, schedule_file(name))
    schedule.each_jobs do |job|
      client.job.create_or_update_freestyle(job.params.dup)
    end
  end

  desc "version", "Display jenkins_cron version"
  map ["-v", "--version"] => :version
  def version
    puts JenkinsCron::VERSION
  end

  private

  def client
    @client ||= JenkinsApi::Client.new(config)
  end

  def config
    @config ||= YAML.load_file(config_file)
  rescue SyntaxError
    error("Can't parse config file: #{config_file}")
  end

  def config_file
    @config_file ||= options[:config]
    unless File.exists? @config_file
      error("Can't find config file: #{@config_file}")
    end
    @config_file
  end

  def schedule_file(name)
    file = "config/schedule/#{name}.rb"
    unless File.exists? file
      error("Can't find schedule file: #{file}")
    end
    file
  end

  def error(message)
    puts "ERROR: #{message}"
    exit 1
  end
end
