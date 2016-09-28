class EventManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :amount, :user_id , presence: true
  
  def user_name
  	self.user.name rescue nil
  end

end
