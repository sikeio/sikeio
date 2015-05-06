require 'rails_helper'

#rake db:test:prepare  before run this test
feature "enrollment flow" do
  given(:course) { Course.first }

  given(:enroll_page) { info_course_path(course) }
  given(:user_info) { {"name" => "abcd", "email" => "abcd@gmail.com"} }

  given(:user) { FactoryGirl.create(:user)}
  given(:enrollment) { FactoryGirl.create(:enrollment, course: course.id, user: user.id) }

  feature "enroll stage: " do
    background do
      visit enroll_page
    end
    feature "valid operation: " do
      scenario 'Apply with right info' do
        find_field("name").set(user_info["name"])
        find_field("email").set(user_info["email"])
        find_button("申请加入").click
        expect(page.status_code).to eq(200)
      end
    end

    feature "invalid operation" do
      scenario 'Apply without fill name' do
        find_field("email").set(user_info["email"])
        find_button("申请加入").click
        expect(page).to have_content("请输入你的姓名和邮箱")
      end

      scenario 'Apply without fill email' do
        find_field("name").set(user_info["name"])
        find_button("申请加入").click
        expect(page).to have_content("请输入你的姓名和邮箱")
      end

      scenario 'Apply with incorrect email' do
        find_field("name").set(user_info["name"])
        find_field("email").set("invalide_email")
        find_button("申请加入").click
        expect(page).to have_content("报名失败")
      end
    end
  end

  feature "invite" do
    given(:auth_success) do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
        "provider" => 'github',
        "uid" => '123545',
        "info" => {
          "nickname" => user_info["name"],
          "email" => user_info["email"]
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

    background do
      OmniAuth.config.mock_auth[:github] = nil
    end

    given(:personal_info) { {"blog_url" => "blog.com", "occupation" => "无业" } }


    feature "valid page operation" do

      scenario 'Bind github successful' do
        auth_success
        visit invite_enrollment_path(enrollment)
        click_on('Github 绑定')
        expect(page).to have_content("Github 绑定账号: #{user_info["name"]}")
      end

      scenario 'Go to pay page with github binded and info filled' do
        FactoryGirl.create(:authentication, user: user.id)
        visit invite_enrollment_path(enrollment)
        find_field("personal_info[blog_url]").set(personal_info["blog_url"])
        choose("学生")
        click_on("下一步")
        expect(page.current_path).to eq(pay_enrollment_path(enrollment))
      end

    end

    feature "invalid page operation" do

      scenario 'Intend to go to pay page without filling personal info' do
        visit invite_enrollment_path(enrollment)
        FactoryGirl.create(:authentication, user: user.id)
        click_on("下一步")
        expect(page.current_path).to eq(invite_enrollment_path(enrollment))
      end

      scenario 'Intend to go to pay page without binding github' do
        visit invite_enrollment_path(enrollment)
        find_field("personal_info[blog_url]").set(personal_info["blog_url"])
        choose("学生")
        expect(page.current_path).to eq(invite_enrollment_path(enrollment))
      end

      scenario 'Bind github fail' do
        auth_fail
        visit invite_enrollment_path(enrollment)
        click_on('Github 绑定')
        expect(page.current_path).to eq(root_path)
      end

    end

  end

  feature "pay", js: true do
    given(:personal_info) { {"blog_url" => "blog.com", "occupation" => "无业" } }

    scenario 'User whose enrollment has already activate intend to visit pay page' do
      enrollment.update(activated: true)
      page.set_rack_session(user_id: user.id)
      visit pay_enrollment_path(enrollment)
      expect(page.current_path).to eq(course_path(enrollment.course) + "/")
    end

    scenario 'User pays successful' do
      page.set_rack_session(user_id: user.id)
      FactoryGirl.create(:authentication, user: user.id)
      enrollment.update(personal_info: personal_info)
      visit pay_enrollment_path(enrollment)

      page.execute_script("$('input').show()") # capybara connot click hidden checkbox.  shit!

      find("#have-paid").set(true)
      click_on("开始课程")
      expect(page.current_path).to eq(course_path(enrollment.course) + "/")
    end

    scenario 'User intends to complete paying without choose check box' do
      page.set_rack_session(user_id: user.id)
      FactoryGirl.create(:authentication, user: user.id)
      enrollment.update(personal_info: personal_info)
      visit pay_enrollment_path(enrollment)
      click_on("开始课程")
      expect(page).to have_content("请先通过支付宝付款再开始课程")
    end

  end
end

