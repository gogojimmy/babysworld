class Banner < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :url, :banner
  mount_uploader :banner, BannerUploader
  process_in_background :banner
  store_in_background :banner

  scope :available, where("start_date < ? and end_date > ?", Time.now, Time.now)
end
