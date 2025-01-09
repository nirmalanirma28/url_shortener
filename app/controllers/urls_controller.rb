class UrlsController < ApplicationController
    before_action :authenticate_token, only: [:create, :redirect]
  
    def create
      @url = Url.new(url_params)
  
      if @url.save
        render json: { long_url: @url.long_url, short_url: @url.shortened_url }, status: :created
      else
        render json: @url.errors, status: :unprocessable_entity
      end
    end

    def redirect
      @url = Url.find_by(shortened_url: params[:url])
  
      if @url
        render json: { long_url: @url.long_url }, status: :ok
      else
        render json: { error: 'URL not found' }, status: :not_found
      end
    end

    def generate_token
        token = JWT.encode({ user_id: 1 }, "url_shortener", 'HS256')
        render json: { token: token }, status: :ok
    end
  
    def url_params
      params.require(:url).permit(:long_url)
    end
  end
  