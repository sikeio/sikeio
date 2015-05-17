FactoryGirl.define do

  factory :enrollment do
    transient do
      user nil
      course nil
      info nil
      active nil
    end

    user_id { user }
    course_id { course }
    personal_info {"#{info}" if info}
    start_time { Time.now }
    activated {true if active}
  end

  factory :user do
    name "test_user"
    email "test_user@gmail.com"
  end

  factory :course do
    name "test_course"
  end

  factory :authentication do
    transient do
      user nil
    end

    user_id { user }
    provider { "github" }
    info { { "info" => { "nickname" => "nick"} } }
  end

end

