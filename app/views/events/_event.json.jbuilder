json.extract! event, :id, :event_type, :event_date, :location, :total_amount, :created_at, :updated_at
json.url event_url(event, format: :json)