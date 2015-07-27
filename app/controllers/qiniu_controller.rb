class QiniuController < ApplicationController

  def sike_uptoken
    @uptoken = get_uptoken(ENV['QINIU_SIKE_BUCKET'])
    render "uptoken.json.jbuilder"
  end

  def resume_uptoken
    @uptoken = get_uptoken(ENV['QINIU_RESUME_BUCKET'])
    render "uptoken.json.jbuilder"
  end

  private

  def get_uptoken(bucket)
    put_policy = Qiniu::Auth::PutPolicy.new(bucket)
    put_policy.save_key = "$(etag)$(ext)"
    Qiniu::Auth.generate_uptoken(put_policy)
  end
end
