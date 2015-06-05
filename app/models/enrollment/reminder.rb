class Enrollment::Reminder

  MAX_REMINDER_COUNT = 5
  SCHEDULE = [2, 5, 3, 10, 10]

  attr_reader :enrollment


  def initialize(enrollment)
    @enrollment = enrollment
  end

  def refresh_reminder_state
    if not_activated_state?
      set_reminder_state("not_activated")
    elsif not_first_checkin_state?
      set_reminder_state("no_first_checkin")
    elsif checkin_late_state?
      set_reminder_state("checkin_late")
    else
      set_reminder_state(nil)
    end
  end

  def update_last_checkin_time
    enrollment.update!(last_checkin_time: Time.now)
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
    schedule_next_reminder
  end

  private

  def set_reminder_state(state)
    if enrollment.reminder_state != state
      enrollment.update(reminder_state: state)
      schedule_next_reminder(true)
      if state == nil
        enrollment.update(reminder_scheduled_at: nil)
      end
    end
  end

  def schedule_next_reminder(reset = false)
    if reset
      enrollment.update(reminder_count: 0, reminder_disabled: false)
    end

    reminder_count = enrollment.reminder_count

    if reminder_count >= MAX_REMINDER_COUNT
      enrollment.update(reminder_scheduled_at: nil, reminder_disabled: true)
    else
      reminder_scheduled_at = SCHEDULE[reminder_count].days.since.beginning_of_day
      enrollment.update(reminder_scheduled_at: reminder_scheduled_at)
    end
  end

  def not_activated_state?
    if enrollment.activated? || !enrollment.invitation_sent_time
      return false
    end

    if enrollment.invitation_sent_time < 2.days.ago
      return true
    else
      return false
    end
  end

  def not_first_checkin_state?
    if enrollment.activated? && enrollment.checkins.count == 0 && enrollment.schedule.any_released?
      return true
    else
      return false
    end
  end

  def checkin_late_state?
    if !enrollment.last_visit_time
      return false
    end

    if (enrollment.last_visit_time < 2.days.ago) && (enrollment.schedule.number_of_lessons_from_current >= 2)
      return true
    else
      return false
    end
  end
end
