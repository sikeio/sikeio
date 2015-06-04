class Enrollment::Reminder

  MAX_REMINDER_COUNT = 5
  SCHEDULE = [2, 5, 3, 10, 10]

  attr_reader :enrollment


  def initialize(enrollment)
    @enrollment = enrollment
  end

  def refresh_reminder_state
    update_number_of_lessons_from_current
    if not_activated_state?
      if enrollment.reminder_state != "not_activated"
        enrollment.update(reminder_state: "not_activated")
        reset_state
      end
    elsif not_first_checkin_state?
      if enrollment.reminder_state != "not_first_checkin_state"
        enrollment.update(reminder_state: "not_first_checkin_state")
        reset_state
      end
    elsif checkin_late_state?
      if enrollment.reminder_state != "checkin_late"
        enrollment.update(reminder_state: "checkin_late")
        reset_state
      end
    else
      if enrollment.reminder_state
        enrollment.update(reminder_state: nil, reminder_count: 0, reminder_scheduled_at: nil, reminder_disabled: false)
      end
    end
  end

  def update_visit_time
    enrollment.update!(last_visit_time: Time.now)
  end

  def update_last_checkin_time
    enrollment.update!(last_checkin_time: Time.now)
  end

  def update_number_of_lessons_from_current
    return if !enrollment.schedule.any_released?
    schedule = enrollment.schedule
    current_lesson = schedule.current_lesson
    latest_released_lesson = schedule.latest_released_lesson
    if current_lesson
      number_of_lessons_from_current = schedule.lesson_number(latest_released_lesson) - schedule.lesson_number(current_lesson) + 1
      enrollment.update(number_of_lessons_from_current: number_of_lessons_from_current)
    else
      enrollment.update(number_of_lessons_from_current: 0)
    end
  end

  def send_reminder_email
    return if enrollment.reminder_disabled? || (!enrollment.reminder_state)
    reminder_state = enrollment.reminder_state

    if reminder_state == "not_activated"
      UserMailer.reinvite(enrollment).deliver_later
    elsif reminder_state == "no_first_checkin"
      UserMailer.no_first_checkin(enrollment).deliver_later
    elsif reminder_state == "checkin_late"
      UserMailer.checkin_late(enrollment).deliver_later
    end

    reminder_count = enrollment.reminder_count + 1
    enrollment.update(reminder_count: reminder_count)
    set_reminder_var
  end

  private

  def set_reminder_var
    reminder_count = enrollment.reminder_count
    if reminder_count >= MAX_REMINDER_COUNT
      enrollment.update(reminder_scheduled_at: nil, reminder_disabled: true)
    else
      reminder_scheduled_at = SCHEDULE[reminder_count].days.since
      enrollment.update(reminder_scheduled_at: reminder_scheduled_at)
    end
  end

  def reset_state
    reminder_scheduled_at = SCHEDULE[0].days.since.beginning_of_day
    enrollment.update(reminder_count: 0, reminder_scheduled_at: reminder_scheduled_at, reminder_disabled: false)
  end

  def not_activated_state?
    return false if enrollment.activated? || (!enrollment.invitation_sent_time)
    if enrollment.invitation_sent_time < 2.days.ago
      return true
    else
      return false
    end
  end

  def not_first_checkin_state?
    if enrollment.activated? && (enrollment.checkins.count == 0) && enrollment.schedule.any_released?
      return true
    else
      return false
    end
  end

  def checkin_late_state?
    return false if !enrollment.last_visit_time
    if (enrollment.last_visit_time < 2.days.ago) && (enrollment.number_of_lessons_from_current >= 2)
      return true
    else
      return false
    end
  end
end
