class Employee < ApplicationRecord
  has_secure_password :pin

  validates :name, presence: true
  validates :position, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validates :pin,
    length: { is: 4 },
    format: { with: /\A\d{4}\z/, message: "must be 4 digits" },
    allow_nil: true
end
