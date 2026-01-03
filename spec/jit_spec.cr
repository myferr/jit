require "./spec_helper"

describe Jit do
  it "has a version" do
    Jit::VERSION.should_not be_nil
  end

  it "can create a Command" do
    cmd = Jit::Command.new("status")
    cmd.name.should eq("status")
    cmd.args.should be_empty
    cmd.options.should be_empty
  end

  it "can create a Command with args and options" do
    options = Hash(String, String | Bool).new
    options["message"] = "test"
    cmd = Jit::Command.new("commit", ["-m", "test"], options)
    cmd.name.should eq("commit")
    cmd.args.should eq(["-m", "test"])
    cmd.options["message"].should eq("test")
  end
end
