class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id

  belongs_to :parent, :class_name => 'Category'
  has_many :children, :class_name => 'Category', :foreign_key => 'parent_id'
  has_many :products

  scope :without, lambda { |category| where('id != ?', category.id) }
  scope :root_only, where('parent_id is null').includes(:children)

  def self.get_all_ids(id)
    self.select("id").find(id).children.pluck("id") << id
  end

  def parent_categories
    categories = [self]
    parent_d = self.parent
    while !parent_d.nil?
      categories << parent_d
      parent_d = parent_d.parent
    end
    categories.reverse
  end

  def root_category
    root = self.parent
    unless root.nil?
      root = root.root_category
    else
      root
    end
  end

  module FindByCategoryScope
    def by_category(category_id=nil)
      (category_id.present?)? where( :category_id => Category.get_all_ids(category_id) ) : scoped
    end
  end

end
