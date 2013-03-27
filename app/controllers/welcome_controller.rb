class WelcomeController < ApplicationController
  def index
  end

  def about
  end

  def terms
  end

  def user_consignment
  end

  def consignment_about
  end

  def faq
  end

  def robots
    robots = File.read(Rails.root + "config/robots.#{Rails.env}.txt")
    render :text => robots, :layout => false, :content_type => "text/plain"
  end
end
