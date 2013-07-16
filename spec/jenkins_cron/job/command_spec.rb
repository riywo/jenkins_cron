describe JenkinsCron::Job::Command do
  it "create a simple example of job/command" do
    cmd = JenkinsCron::Job::Command.new "env | sort"
    expect(cmd.shell_command).to eq(<<-EOF)
bash -c 'env | sort'
EOF
  end
  it "create an example of job/command with options" do
    cmd = JenkinsCron::Job::Command.new "env | sort", env: {PORT: 5000}, user: "app", cwd: "/var/app"
    expect(cmd.shell_command).to eq(<<-EOF)
export PORT=5000
sudo -u app -H bash -l -c 'cd /var/app && env | sort'
EOF
  end
end
