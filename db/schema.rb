# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130409170207) do

  create_table "banners", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "url"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "banner"
    t.boolean  "banner_processing"
    t.string   "banner_tmp"
  end

  create_table "billings", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "done",       :default => false
    t.integer  "amount"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "billings", ["user_id"], :name => "index_billings_on_user_id"

  create_table "consignment_products", :force => true do |t|
    t.string   "name"
    t.integer  "consignment_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "brand"
    t.string   "path"
    t.boolean  "warranty",              :default => false
    t.boolean  "guarantee",             :default => false
    t.integer  "price",                 :default => 0
    t.string   "how_new"
    t.text     "short_coming"
    t.text     "comment"
    t.string   "dealing_status",        :default => "等待處理"
    t.string   "attachment"
    t.string   "attachment_tmp"
    t.boolean  "attachment_processing"
    t.integer  "product_id"
    t.integer  "billing_id"
  end

  add_index "consignment_products", ["billing_id"], :name => "index_consignment_products_on_billing_id"
  add_index "consignment_products", ["consignment_id"], :name => "index_consignment_products_on_consignment_id"
  add_index "consignment_products", ["product_id"], :name => "index_consignment_products_on_product_id"

  create_table "consignments", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "phone"
    t.string   "status"
    t.string   "chinese_name"
    t.string   "attachment"
    t.string   "attachment_tmp"
    t.boolean  "attachment_processing"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "argu_price",            :default => false
    t.boolean  "allow_fix",             :default => false
    t.string   "bank"
    t.string   "account"
    t.string   "bank_num"
    t.string   "account_num"
    t.integer  "balance",               :default => 0
    t.boolean  "payed"
  end

  add_index "consignments", ["user_id"], :name => "index_consignments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "product_images", :force => true do |t|
    t.string   "image"
    t.string   "product_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.boolean  "image_processing"
    t.string   "image_tmp"
  end

  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name",                                             :null => false
    t.text     "description",                                      :null => false
    t.integer  "original_price", :default => 0
    t.integer  "price",          :default => 0
    t.string   "ruten_no",                                         :null => false
    t.integer  "user_id",                                          :null => false
    t.string   "status",         :default => "waiting_for_review"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.text     "pattern"
    t.text     "notice"
    t.integer  "category_id"
  end

  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["name"], :name => "index_products_on_name"
  add_index "products", ["status"], :name => "index_products_on_status"
  add_index "products", ["user_id"], :name => "index_products_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "username",               :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "provider"
    t.string   "uid"
    t.boolean  "is_admin",               :default => false
    t.boolean  "terms",                  :default => true
    t.boolean  "marketing",              :default => true
    t.string   "address"
    t.string   "phone"
    t.string   "chinese_name"
    t.string   "bank"
    t.string   "account"
    t.string   "bank_num"
    t.string   "account_num"
    t.integer  "money_can_apply",        :default => 0
    t.integer  "money_already_earned",   :default => 0
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["is_admin"], :name => "index_users_on_is_admin"
  add_index "users", ["provider"], :name => "index_users_on_provider"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid"
  add_index "users", ["username"], :name => "index_users_on_username"

end
