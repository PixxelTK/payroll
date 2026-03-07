class Employee < ApplicationRecord
  POSITIONS = [
    "Manager",
    "Developer",
    "Designer",
    "Human Resource",
    "Accountant"
  ].freeze

  has_secure_password :pin

  validates :name, presence: true
  validates :position, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :position, inclusion: { in: POSITIONS }

  validates :pin,
    length: { is: 4 },
    format: { with: /\A\d{4}\z/, message: "must be 4 digits" },
    allow_blank: true
end
