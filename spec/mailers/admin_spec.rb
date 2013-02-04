require "spec_helper"

describe Admin do
  describe "notice_consignment" do
    let(:mail) { Admin.notice_consignment }

    it "renders the headers" do
      mail.subject.should eq("Notice consignment")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
