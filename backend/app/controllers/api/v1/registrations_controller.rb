# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: { user: user_json(resource) }, status: :ok
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_content
        end
      end

      # deviseのデフォルトではemail + passwordのみ許可。usernameを追加
      def sign_up_params
        params.expect(user: %i[username email password password_confirmation])
      end

      def user_json(user)
        user.as_json(only: %i[id username email avatar_url bio created_at])
      end
    end
  end
end
