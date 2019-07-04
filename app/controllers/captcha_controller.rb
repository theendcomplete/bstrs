require 'will_paginate/array'
require 'RMagick'
class CaptchaController < ApplicationController

  def index
    # @captchas = Captcha.find_each(batch_size: 100).paginate(page: params[:page], per_page: 30).order('created_at DESC')
    @captchas = Captcha.where(solution: nil).last(15)
    @captchas = @captchas.paginate(page: params[:page], per_page: 15)
  end

  def solve
    @captcha_to_edit = Captcha.find(params['id'])
    if @captcha_to_edit.update(captcha_params)
      #TODO переделать на что-то более безопасное
      param_str = @captcha_to_edit.request_response.params
      rr_params = param_str.gsub(/"usr(.*?)>,/, '')
      rr_params = eval(rr_params)
      rr_params['captcha_sid'] = @captcha_to_edit.captcha_sid
      rr_params['captcha_key'] = @captcha_to_edit.solution
      @result = URI.parse(@captcha_to_edit.request_response.url + rr_params.to_query.to_s).read
      captcha_to_edit.update_attribute('result', @result)
      respond_to do |format|
        format.js {render partial: 'captcha/result'}
      end
      @result
    end
  end

  def captcha_params
    accessible = %i[captcha_sid captcha_key id solution] # extend with your own params
    params.permit(accessible)
  end
end
