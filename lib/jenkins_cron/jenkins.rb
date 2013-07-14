require "jenkins_api_client"

class JenkinsCron::Jenkins
  def initialize(config)
    @client = JenkinsApi::Client.new(config)
  end

  def update(schedule)
    schedule.each_jobs do |job|
      @client.job.create_or_update_freestyle(job.params.dup)
    end

    @client.view.create_list_view(
      name: schedule.name,
      regex: "^#{schedule.name}-.+",
    ) unless @client.view.exists?(schedule.name)
  end
end
