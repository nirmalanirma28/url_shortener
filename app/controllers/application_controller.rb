class ApplicationController < ActionController::API
    def authenticate_token
        header = request.headers['token']
        if header.present?
          begin
            decoded_token = JWT.decode(header, "url_shortener", true, algorithm: 'HS256')
            @current_user = decoded_token.first[1] # we should have the user id here, for now I'm using a dummy user id as 1
          rescue JWT::DecodeError
            render json: { error: 'Invalid or expired token' }, status: :unauthorized
          end
        else
          render json: { error: 'Missing token' }, status: :unauthorized
        end
    end
end
