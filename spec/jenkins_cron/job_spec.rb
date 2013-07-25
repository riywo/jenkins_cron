describe JenkinsCron::Job do
  it "create a simple example of job" do
    schedule = JenkinsCron::Schedule.new :schedule1
    job = JenkinsCron::Job.new schedule, :test1 do
      command "echo test1"
      timer every: 5.minute
      timer every: :Monday
    end

    expect(job.name).to be(:test1)
    expect(job.params[:name]).to eq("schedule1-test1")
    expect(job.params[:shell_command]).to eq("bash -c 'echo test1'\n")
    expect(job.params[:timer]).to eq("H/5 * * * *\nH H * * 1")
  end
end
