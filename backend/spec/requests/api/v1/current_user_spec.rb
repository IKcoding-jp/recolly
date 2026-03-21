# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::CurrentUser', type: :request do
  let!(:user) do
    User.create!(username: 'testuser', email: 'test@example.com', password: 'password123')
  end

  describe 'GET /api/v1/current_user（認証済みユーザー情報）' do
    context '正常系' do
      it 'ログイン済みでユーザー情報を取得できる（200）' do
        sign_in user
        get api_v1_current_user_path, as: :json
        expect(response).to have_http_status(:ok)
      end

      it 'レスポンスにユーザー情報が含まれる' do
        sign_in user
        get api_v1_current_user_path, as: :json
        json = response.parsed_body
        expect(json['user']['email']).to eq('test@example.com')
        expect(json['user']['username']).to eq('testuser')
      end

      it 'レスポンスにパスワード情報が含まれない' do
        sign_in user
        get api_v1_current_user_path, as: :json
        json = response.parsed_body
        expect(json['user']).not_to have_key('encrypted_password')
      end
    end

    context '異常系' do
      it '未ログインで401エラー' do
        get api_v1_current_user_path, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
