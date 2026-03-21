# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work, type: :model do
  describe 'バリデーション' do
    let(:valid_attributes) do
      { title: '進撃の巨人', media_type: 'anime' }
    end

    let(:full_attributes) do
      valid_attributes.merge(
        description: '巨人と人類の戦い',
        cover_image_url: 'https://example.com/image.jpg',
        total_episodes: 25,
        external_api_id: '16498',
        external_api_source: 'anilist',
        metadata: { genres: %w[action drama] }
      )
    end

    it '必須フィールド（title, media_type）で作成できる' do
      work = described_class.new(valid_attributes)
      expect(work).to be_valid
    end

    it '全フィールド指定で作成できる' do
      work = described_class.new(full_attributes)
      expect(work).to be_valid
    end

    it 'titleなしでバリデーションエラー' do
      work = described_class.new(valid_attributes.merge(title: ''))
      expect(work).not_to be_valid
      expect(work.errors[:title]).to be_present
    end

    it 'media_typeなしでバリデーションエラー' do
      work = described_class.new(valid_attributes.merge(media_type: nil))
      expect(work).not_to be_valid
      expect(work.errors[:media_type]).to be_present
    end

    it '無効なmedia_typeでArgumentError' do
      expect do
        described_class.new(valid_attributes.merge(media_type: 'invalid'))
      end.to raise_error(ArgumentError)
    end
  end

  describe 'ユニーク制約' do
    it 'external_api_id + external_api_source が重複するとバリデーションエラー' do
      described_class.create!(title: '進撃の巨人', media_type: 'anime',
                              external_api_id: '16498', external_api_source: 'anilist')
      duplicate = described_class.new(title: '別タイトル', media_type: 'anime',
                                      external_api_id: '16498', external_api_source: 'anilist')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:external_api_id]).to be_present
    end

    it 'external_api_id が同じでも source が違えば作成できる' do
      described_class.create!(title: '進撃の巨人', media_type: 'anime',
                              external_api_id: '16498', external_api_source: 'anilist')
      different_source = described_class.new(title: '進撃の巨人', media_type: 'anime',
                                             external_api_id: '16498', external_api_source: 'tmdb')
      expect(different_source).to be_valid
    end

    it 'external_api_id が nil の場合はユニーク制約の対象外' do
      described_class.create!(title: '手動登録作品1', media_type: 'anime')
      manual = described_class.new(title: '手動登録作品2', media_type: 'anime')
      expect(manual).to be_valid
    end
  end

  describe 'enum' do
    it 'media_type の全値が定義されている' do
      expected = %w[anime movie drama book manga game]
      expect(described_class.media_types.keys).to match_array(expected)
    end
  end

  describe 'リレーション' do
    it 'records を複数持てる' do
      association = described_class.reflect_on_association(:records)
      expect(association.macro).to eq(:has_many)
    end
  end
end
