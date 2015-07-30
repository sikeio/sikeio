class QiniuController < ApplicationController

  def uptoken
    put_policy = Qiniu::Auth::PutPolicy.new(ENV['QINIU_BUCKET'])
    @uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    render "uptoken.json.jbuilder"
  end

end
