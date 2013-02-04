#encoding: utf-8
require 'spec_helper'

describe Admin::ProductsController do
  it "login success with admin" do
    admin = FactoryGirl.create(:admin)
    login_as(admin)
    ap subject.current_user
    visit '/admin/products'
    page.should have_content("新增商品")
    page.should have_content("商品列表")
  end
  it "login failed with user" do
    user = FactoryGirl.create(:user)
    login_as(user)
    visit '/admin/products'
    current_path.should == new_user_session_path
  end
end
