describe JenkinsCron::Job do
  it "create a simple example of job" do
    schedule = JenkinsCron::Schedule.new :schedule1
    job = JenkinsCron::Job.new schedule, :test1 do
      command "echo test1"
      options :timer, "* * * * *"
    end

    expect(job.name).to be(:test1)
    expect(job.params[:name]).to eq("schedule1-test1")
    expect(job.params[:shell_command]).to eq("bash -c 'echo test1'\n")
    expect(job.params[:timer]).to eq("* * * * *")
  end
end
