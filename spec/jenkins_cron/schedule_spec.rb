describe JenkinsCron::Schedule do
  it "is a first test" do
    schedule = JenkinsCron::Schedule.new do
      job :test1 do
        shell_command "echo test1"
        timer "* * * * *"
      end

      job :test2 do
        shell_command "echo test2"
        timer "* * * * *"
      end
    end

    expect(schedule.job(:test1)).to be_true
    expect(schedule.job(:test2)).to be_true
    expect(schedule.job(:test3)).to be_false

    expect(schedule.job(:test1).params[:shell_command]).to eq("echo test1")
    expect(schedule.job(:test2).params[:shell_command]).to eq("echo test2")
  end
end