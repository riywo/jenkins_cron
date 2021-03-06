describe JenkinsCron::Job::Timer do
  it "is a first test" do
    timer = JenkinsCron::Job::Timer.new do
      hour every: 3
      min  :once
    end
    expect(timer.to_s).to eq("H H/3 * * *")
  end

  it "is a second test" do
    timer = JenkinsCron::Job::Timer.new do
      month every: 3
      day   (1..15), every: 2
      day_w 1,5
      hour  1
      min   :once
    end
    expect(timer.to_s).to eq("H 1 H(1-15)/2 H/3 1,5")
  end

  it "is a third test" do
    timer = JenkinsCron::Job::Timer.new every: 3.hours
    expect(timer.to_s).to eq("H H/3 * * *")
  end

  it "is a forth test" do
    timer = JenkinsCron::Job::Timer.new every: 2.weeks
    expect(timer.to_s).to eq("H H H/14 * *")
  end

  it "is a fifth test" do
    timer = JenkinsCron::Job::Timer.new every: 3.hours, min: 29
    expect(timer.to_s).to eq("29 H/3 * * *")
  end

  it "is a sixth test" do
    timer = JenkinsCron::Job::Timer.new every: 2.days, at: "10:00 pm"
    expect(timer.to_s).to eq("0 22 H/2 * *")
  end

  it "is a seventh test" do
    timer = JenkinsCron::Job::Timer.new every: :Monday
    expect(timer.to_s).to eq("H H * * 1")
  end

  it "is a eightth test" do
    timer = JenkinsCron::Job::Timer.new every: :Weekday
    expect(timer.to_s).to eq("H H * * 1,2,3,4,5")
  end

  it "is a nineth test" do
    timer = JenkinsCron::Job::Timer.new every: :Weekend, at: "7:00 pm"
    expect(timer.to_s).to eq("0 19 * * 0,6")
  end

  it "is a tenth test" do
    timer = JenkinsCron::Job::Timer.new every: 1.day, month: 4
    expect(timer.to_s).to eq("H H * 4 *")
  end

  it "is a eleventh test" do
    timer = JenkinsCron::Job::Timer.new once_an_hour: 10
    expect(timer.to_s).to eq("H 10 * * *")
  end

  it "is a twelfth test" do
    timer = JenkinsCron::Job::Timer.new once_an_hour: [3,6,12]
    expect(timer.to_s).to eq("H 3,6,12 * * *")
  end

  it "is a thirteenth test" do
    timer = JenkinsCron::Job::Timer.new once_a_day: [3,6,12], hour: 10
    expect(timer.to_s).to eq("H 10 3,6,12 * *")
  end

  it "is a fourteenth test" do
    timer = JenkinsCron::Job::Timer.new once_a_month: [3,6,12], day: 15
    expect(timer.to_s).to eq("H H 15 3,6,12 *")
  end

  it "is a fifteenth test" do
    timer = JenkinsCron::Job::Timer.new once_a_day_w: [:Monday, :Friday]
    expect(timer.to_s).to eq("H H * * 1,5")
  end
end
