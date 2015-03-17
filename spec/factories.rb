FactoryGirl.define do  
  factory :enrollment do
    
  end


  factory :user do
    name "test_user"
    email "test_user@gmail.com"
  end

  factory :test_lesson, class: Lesson do
    sequence(:name) { |n| "test_lesson_#{n + 1}"}
  end

  factory :test_course, class: Course do
    name "test_course"
  end

end

