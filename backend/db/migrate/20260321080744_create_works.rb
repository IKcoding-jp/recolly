# frozen_string_literal: true

class CreateWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :works do |t|
      t.string :title, null: false
      t.integer :media_type, null: false
      t.text :description
      t.string :cover_image_url
      t.integer :total_episodes
      t.string :external_api_id
      t.string :external_api_source
      t.jsonb :metadata, default: {}

      t.timestamps null: false
    end

    # 同じ外部APIの同じIDの作品は重複させない
    add_index :works, %i[external_api_id external_api_source], unique: true,
              where: 'external_api_id IS NOT NULL'
  end
end
