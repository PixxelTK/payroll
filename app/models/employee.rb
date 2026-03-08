class Employee < ApplicationRecord
  has_many :attendances, dependent: :destroy

  def monthly_attendances(date)
    attendances.where(work_date: date.beginning_of_month..date.end_of_month)
  end

  def monthly_working_days(date)
    monthly_attendances(date).where.not(check_out: nil).count
  end

  def monthly_ot_hours(date)
    monthly_attendances(date).sum(&:ot_hours)
  end

  def monthly_ot_pay(date)
    monthly_ot_hours(date) * (salary / 30.0 / 8)
  end

  def monthly_tax(date)
    income = salary + monthly_ot_pay(date)

    if income <= 30000
      0
    elsif income <= 50000
      (income - 30000) * 0.05
    else
      (20000 * 0.05) + ((income - 50000) * 0.10)
    end
  end

  def monthly_net_pay(date)
    records = monthly_attendances(date).where.not(check_out: nil)
    return 0 if records.none?

    salary + monthly_ot_pay(date) - monthly_tax(date)
  end

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
