describe JenkinsCron do
  describe "VERSION" do
    subject { JenkinsCron::VERSION }
    it { should be_a String }
  end
end
