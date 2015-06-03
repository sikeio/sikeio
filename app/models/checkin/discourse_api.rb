class Checkin::DiscourseAPI
  HOST = ENV["DISCOURSE_HOST"]
  TOKEN = ENV["DISCOURSE_TOKEN"]
  ADMIN = ENV["DISCOURSE_ADMIN"]

  MYAPI = "#{HOST}/myapi"

  def discourse_user(username)
    url = HOST + "/admin/users/#{username}.json"
    begin
      r = RestClient.get url, :params => {:api_key => TOKEN, :api_username => ADMIN}
      return JSON.parse(r.body)
    rescue => e
      return nil
    end
  end

  def create_discourse_user(username, email)
    url = ENV["DISCOURSE_HOST"] + "/users"

    r = RestClient.post url, {
      :username => username,
      :email => email,
      :password => SecureRandom.hex(10), # Find a way to generate password
      :active => true
    },{
      :accept => :json,
      :params => {
        :api_key => TOKEN,
        :api_username => ADMIN
      }
    }
    result = JSON.parse(r.body)
    result["user_id"]
  end

  def create_topic(title, raw, category, username = ENV['DISCOURSE_ADMIN'])
    # raw:and we are going to say something quite random
    # reply_to_post_number:
    # category:category_name
    # archetype:regular
    # title:hello world this is a new topic
    if raw.empty?
      raise "Cant't create discourse topic with empty content!"
    end
    url = "#{HOST}/posts"
    r = RestClient.post url, {
      raw: raw,
      title: title,
      archetype: "regular",
      category: category,
    }, {
      :accept => :json,
      :params => {
        skip_validations: true,
        :api_username => username,
        :api_key => TOKEN
      }
    }
    JSON.parse(r.body)
  end

  def update_topic(user_name,topic_id,topic_slug,title,category)
    url="#{HOST}/t/#{topic_slug}/#{topic_id}"
    r=RestClient.put url,{
      title: title,
      category: category
    },{
      :accept => :json,
      :params => {
        skip_validations: true,
        :api_username => username,
        :api_key => TOKEN
      }
    }
    JSON.parse(r.body)
  end


  def update_post(post_id,user_name,raw)
    # raw:and we are going to say something quite random
    # reply_to_post_number:
    # category:category_name
    # archetype:regular
    # title:hello world this is a new topic
    url = "#{HOST}/posts/#{post_id}"
    r = RestClient.put url, {
      post: {
        raw: raw,
        archetype: "regular",
      },
    }, {
        :accept => :json,
        :params => {
          :skip_validations => true,
          :api_username => user_name,
          :api_key => TOKEN
        }
      }
    JSON.parse(r.body)
  end

  def create_post(topic_id,user_name,raw)
    thread_url = "#{HOST}/posts"
    r = RestClient.post thread_url, {
      :topic_id => topic_id,
      :raw => raw,
    }, {
        :accept => :json,
        :params => {
          :skip_validations => true,
          :api_username => user_name,
          :api_key => TOKEN
        }
      }
    JSON.parse(r.body)
  end

  def user(query)
    url = "#{MYAPI}/user"
    query = query.slice(:email,:github_id)
    r = RestClient.get url, :params => query.merge(api_key: TOKEN)
    JSON.parse(r.body)
  end

  # Find category by name
  #
  # Example:
  #   category("公告") # => {"id"=>5, "name"=>"公告"}
  def category(name)
    url = "#{MYAPI}/category/#{URI.escape name}"
    r = RestClient.get url, :params => {
      :api_key => TOKEN
    }
    JSON.parse(r.body)
  end
end
