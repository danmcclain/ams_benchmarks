class Note < ActiveRecord::Base
  has_many :tags
end
