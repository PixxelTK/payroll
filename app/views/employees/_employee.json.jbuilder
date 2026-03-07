json.extract! employee, :id, :name, :position, :salary, :pin_digest, :created_at, :updated_at
json.url employee_url(employee, format: :json)
