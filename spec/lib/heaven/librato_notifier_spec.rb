require "spec_helper"

describe "Heaven::Notifier::Librato" do
  it "ignores pending notifications" do
    Heaven.redis.set("atmos/my-robot-production-revision", "sha")

    n = Heaven::Notifier::Librato.new(fixture_data("deployment-pending"))
    expect(n.default_message).to be_nil
  end

  it "handles successful deployment statuses" do
    n = Heaven::Notifier::Librato.new(fixture_data("deployment-success"))

    expected = "atmos's deployment of my-robot (daf81923) is done."
    expect(n.default_message).to eql(expected)
  end

  it "handles failure deployment statuses" do
    n = Heaven::Notifier::Librato.new(fixture_data("deployment-failure"))

    expected = "atmos's deployment of my-robot (daf81923) failed."
    expect(n.default_message).to eql(expected)
  end
end
