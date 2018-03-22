json.extract! user_thing, :id, :name, :user_id, :created_at, :updated_at
json.url user_thing_url(user_thing, format: :json)
