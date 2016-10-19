class Article < ActiveRecord::Base
  validates :path, presence: true
  
  def to_param
    path
  end
end
