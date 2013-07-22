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
    timer = JenkinsCron::Job::Timer.new every: 1.weeks, at: "10:00 pm"
    expect(timer.to_s).to eq("0 22 H/7 * *")
  end
end
