class Event < ActiveRecord::Base
  EVENT_TYPE_ENUM = ["LUNCH","DINNER","SNACKS"]
  has_many :event_managers
  has_many :users , :through => :event_managers
  validates :event_date, :location,:total_amount, presence: true
  validates_associated :event_managers
  validate :limit_event_managers

  accepts_nested_attributes_for :event_managers,:allow_destroy => true



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
     own_summary_statement_html += "<p> #{max_paid_user} #{users.count == 1 ? 'own' : 'owns'}  $ #{(per_user_amount_pay - user.amount)/(users.count)} each from #{user.user_name}</p>" if user.amount < per_user_amount_pay
    end
    own_summary_statement_html = "<p> Everyone pay properly </p>" if own_summary_statement_html.blank?
    own_summary_statement_html
  end

  def self.overall_summary
    user_event_summary = EventManager.group(:user_id).sum(:amount)
    summary = {}
    user_event_summary.each do |user_id,value|
      amount_spent = value
      event_managers = EventManager.where(user_id: user_id).order("event_id desc")
      event_ids = event_managers.pluck(:event_id).uniq rescue [] if event_managers.present?
      events = Event.where(id: event_ids).order("id desc") if event_ids.present?
      total_amount = events.sum(:total_amount) if events.present?
      if amount_spent < total_amount
        amount_to_pay = total_amount - amount_spent
        per_user_amount_to_pay = {}
        amount_paid = {}
        events.each{|event| per_user_amount_to_pay[event.per_user_amount] = event.event_managers.group(:user_id).sum(:amount)}
        per_user_amount_to_pay.each do |amount_to_pay, user_payment|
          logger.info user_payment.inspect
          user_payment.each do |current_user, payment| 
            next if  user_payment[user_id] >= amount_to_pay
            if payment > amount_to_pay
              
              value = summary[User.find(current_user).name].present? ? ([summary[User.find(current_user).name]] + [[payment - amount_to_pay,User.find(user_id).name]]) : ([payment - amount_to_pay,User.find(user_id).name])
              summary[User.find(current_user).name] = value
            end
            #summary << "#{User.find(current_user).name} owe $ #{payment - amount_to_pay} from #{User.find(user_id).name}" if payment > amount_to_pay
           end
        end
      end
    end
    self.convert_to_summary(summary)
    #summary.to_sentence(:words_connector => ' , ',:last_word_connector=> " and ") rescue nil
  end


  def self.convert_to_summary(summary_hash)
    summary_html = ""
    summary_hash.each do |summary_own_user,summary_values|
      user_amount_owe_hash = Hash.new(0)
      summary_values = summary_values.flatten
      summary_values.each_with_index do |value_hash,index| 
        value = 0
        value = user_amount_owe_hash[value_hash] if user_amount_owe_hash[value_hash].present?
        user_amount_owe_hash[value_hash] = value + summary_values[index-1] if index.odd?
      end
      hash_to_sentence = user_amount_owe_hash.collect{|hash| "$ #{hash[1]} from #{hash[0]}"}
      hash_to_sentence.each do |sentence| 
        summary_html += "<p>#{summary_own_user} owns #{sentence}</p>"
      end
    end
    summary_html
  end

  private
  def limit_event_managers
    user_count = User.count
     errors.add(:base, "You can have #{user_count} fields") if user_count > self.event_managers.length
  end
end
