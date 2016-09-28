class User < ActiveRecord::Base
  has_many :event_managers
  has_many :events , :through => :event_managers
  validates :name, presence: true
  
end
