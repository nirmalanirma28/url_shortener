require 'rails_helper'

RSpec.describe "UrlsController", type: :controller do
    let(:valid_token) { JWT.encode({ user_id: 1 }, "url_shortener", 'HS256') }
    let(:headers) { { 'Token' => valid_token } }
    let(:long_url) { 'https://example.com' }

    before do
        @controller = UrlsController.new
    end
  
    context 'shortened url generation' do
      it 'creates a shortened URL with a valid token' do
        request.headers.merge!(headers)
        post :create, params: { url: { long_url: long_url }}
        expect(response).to have_http_status(:created)
      end
  
      it 'returns unauthorized without a token' do
        post :create, params: { long_url: long_url }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  
    context 'long url redirect' do
        it 'redirects to the original URL with a valid token' do
            request.headers.merge!(headers)
            Url.create!(long_url: long_url, shortened_url: 'abc123')
            get :redirect, params:  { url: 'test' }
            expect(response).to have_http_status(:not_found)
        end
        it 'redirects to the original URL without a token' do
            Url.create!(long_url: long_url, shortened_url: 'abc123')
            get :redirect, params: { shortened_url: 'abc123' }
            expect(response).to have_http_status(:unauthorized)
        end
    end
  end
  