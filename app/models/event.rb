class Event < ActiveRecord::Base
  EVENT_TYPE_ENUM = ["LUNCH","DINNER","SNACKS"]
  has_many :event_managers
  has_many :users , :through => :event_managers
  validates :event_date, :location,:total_amount, presence: true
 
  accepts_nested_attributes_for :event_managers,:allow_destroy => true,:limit=> User.count

  

  # attr_accessor :event_manager_ids, :event_amount_paid_by
  # before_save :save_event_manager_ids


  # def save_event_manager_ids
  # 	return true if self.event_manager_ids.blank? 
  # 	user_ids = self.event_manager_ids 
  #   self.event_managers.destroy_all
  #   user_ids.each do |user_id|

  #     self.event_managers.create(user_id: user_id,amount:)
  #   end
  # end

  def per_user_amount
    (self.total_amount/self.event_managers.count).to_f rescue 0
  end

  def owe_summary
    event_attendee = self.event_managers.where("amount IS NOT NULL or user_id IS NOT NULL").select(:id,:user_id,:amount).order("amount desc")
    max_amount = event_attendee.first.amount rescue nil
    users = event_attendee.collect{|user| user.user_name if user.amount == max_amount}.compact rescue []
    max_paid_user = users.to_sentence(:words_connector => ' , ',:last_word_connector=> " and ") rescue nil if users.present?
    per_user_amount_pay = self.per_user_amount
    own_summary_statement_html = ""
    event_attendee.each do |user|
     own_summary_statement_html += "<p> #{max_paid_user} #{users.count == 1 ? 'own' : 'owns'}  $ #{per_user_amount_pay - user.amount} from #{user.user_name}</p>" if user.amount < per_user_amount_pay
    end
    own_summary_statement_html = "<p> Everyone pay properly </p>" if own_summary_statement_html.blank?
    own_summary_statement_html
  end

end
