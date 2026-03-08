class Attendance < ApplicationRecord
  belongs_to :employee

  validates :work_date, uniqueness: { scope: :employee_id }

  validate :check_times_valid

  def work_hours
    return 0 unless check_out
    (check_out - check_in) / 1.hour
  end

  def ot_hours
    [ work_hours - 8, 0 ].max
  end

  private

  def check_times_valid
    return unless check_in && check_out

    if check_out <= check_in
      errors.add(:check_out, "must be after check in")
    end
  end
end
