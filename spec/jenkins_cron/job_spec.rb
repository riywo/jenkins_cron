describe JenkinsCron::Job do
  it "is a first test" do
    job = JenkinsCron::Job.new :test1 do
      shell_command "echo test1"
      timer "* * * * *"
    end

    expect(job.name).to be(:test1)
    expect(job.params[:shell_command]).to eq("echo test1")
    expect(job.params[:timer]).to eq("* * * * *")
  end
end
