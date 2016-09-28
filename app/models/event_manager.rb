class EventManager < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  delegate :name, to: :user, prefix: true


end
