require 'spec_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :products }
  it "has a valid factory" do
    FactoryGirl.create(:user).should be_valid
  end
end
