require 'spec_helper'

describe Product do
  it { should belong_to :user }
  it { should validate_presence_of :name }
  it { should validate_presence_of :description}
  it { should validate_presence_of :original_price}
  it { should validate_presence_of :price}
  it { should validate_presence_of :url}
  it { should ensure_inclusion_of(:status).in_array(Product::STATUS.keys) }
  it "has valid factory" do
    FactoryGirl.create(:product).should be_valid
  end

  describe ".public_products" do
    it "returns all public products" do
      public_items = []
      private_items = []
      2.times do
        public_items << FactoryGirl.create(:product, :is_public => true)
        private_items << FactoryGirl.create(:product, :is_public => false)
      end
      Product.public_products.should == public_items
    end
  end
end
