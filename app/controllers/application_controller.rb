class ApplicationController < ActionController::Base
  #before_filter :authenticate if Rails.env.staging?
  before_filter :find_tags
  protect_from_forgery

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
       username == "babysworld" && password == "hq0329"
    end
  end

  def authenticate_admin
    current_user && current_user.is_admin?
  end

  def delayed_job_admin_authentication
    authenticate_admin
  end

  def find_tags
    @tags = Product.tag_counts
  end

end
