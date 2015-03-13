FactoryGirl.define do

  factory :user do
    name "test_user"
    email "test_user@gmail.com"

    after(:create) do |user|
      user.courses << FactoryGirl.create(:course)
    end
  end


  factory :course do
    name "ios"
    after(:create) do |course|
      week_day_num = 4
      week_num = 2

      week_num.times do |week_n|
        week_n += 1
        new_week = FactoryGirl.create(:week, num: week_n, course_id: course.id)
        week_day_num.times do |day|
          day += 1
          FactoryGirl.create(:lesson, day: day, week_id: new_week.id,
                            name: "#{course.id} Lesson_#{day * week_n}")
        end
      end

    end
  end

  factory :week do
    title "week_title"
  end

  factory :lesson do
    sequence(:title) { |n| "title_#{n}" }
    sequence(:overview) { |n| "overview_#{n}" }
  end

end

