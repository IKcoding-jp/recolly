# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApplicationController
      before_action :authenticate_user!

      # GET /api/v1/current_user — 認証済みユーザー情報を返す
      def show
        render json: { user: user_json(current_user) }, status: :ok
      end
    end
  end
end
