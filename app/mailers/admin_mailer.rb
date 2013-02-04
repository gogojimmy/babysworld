#encoding: utf-8
class AdminMailer < ActionMailer::Base
  default from: "admin@babysworld.tw"

  def notice_consignment(consignment)
    @consignment = consignment
    mail to: "admin@babysworld.tw", subject: '有一則新的託售請求'
  end
end
