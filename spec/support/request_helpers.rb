#encoding: utf-8
module RequestHelpers
  def logout_user(user = @current_user)
    Capybara.reset_sessions!
    visit destroy_user_session_url
  end

  def login_as(sym)
    logout_user if @current_user
    @current_user = sym
    visit new_user_session_url
    fill_in :user_email, :with => @current_user.email
    fill_in :user_password, :with => @current_user.password
    save_and_open_page
    #click_button "登入"
  end

end
