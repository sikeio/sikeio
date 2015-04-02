FactoryGirl.define do  factory :checkout do
    
  end
  

  factory :check_out  do
    lesson_name "check_out_lesson"
  end
  
  factory :enrollment do

  end

  factory :lesson_checked, class: Lesson do
    name "check_out_lesson"
  end

  factory :lesson_not_checked, class: Lesson do
    name "no_check_out_lesson"
  end

  factory :user do
    name "test_user"
    email "test_user@gmail.com"
  end

  factory :test_lesson, class: Lesson do
    sequence(:name) { |n| "test_lesson_#{n}"}
  end

  factory :test_course, class: Course do
    name "test_course"
    current_version "v1"
  end

end

