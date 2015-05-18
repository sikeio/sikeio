require 'rails_helper'

#rake db:test:prepare before run this test
feature "login flow" do
  given(:course) { Course.find_by(name: "nodejs") }

  given(:user_info) { {"name" => "abcd", "email" => "abcd@gmail.com"} }
  given(:user) { FactoryGirl.create(:user) }

  given(:auth_success) do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      "provider" => 'github',
      "uid" => '123545',
      "info" => {
        "nickname" => user.name,
        "email" => user.email
      }
    })
  end

  given(:auth_fail) do
    OmniAuth.config.mock_auth[:github] = :auth_fail
  end

  background(:all) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
  end

  feature "Visit login page: " do
    scenario  "Land the page" do
      visit login_path
      expect(page.status_code).to eq(200)
    end
  end

  feature "User login:" do
    background do
      visit login_path
    end

    feature "auth success:" do
      background do
        user
        auth_success
      end

      scenario "login with no course enrolled" do
        click_on "GitHub登入"
        expect(page.current_path).to eq(courses_path)
        expect(page).to have_content("你还没有加入任何课程")
      end

      scenario "login with one course enrolled" do
        FactoryGirl.create(:enrollment, course: course.id, user: user.id, active: true)
        click_on "GitHub登入"
        expect(page.current_path).to eq(course_path(course) + "/")
      end

      scenario "login with more than one course enrolled" do
        course2 = FactoryGirl.create(:course)
        FactoryGirl.create(:enrollment, course: course.id, user: user.id, active: true)
        FactoryGirl.create(:enrollment, course: course2.id, user: user.id, active: true)
        click_on "GitHub登入"
        expect(page.current_path).to eq(courses_path)
        expect(page).not_to have_content("你还没有加入任何课程")
        course2.delete
      end

    end

    feature "auth fail:" do
      scenario "login fail" do
        auth_fail
        click_on "GitHub登入"
        expect(page.current_path).to eq(root_path)
      end
    end
  end
end
