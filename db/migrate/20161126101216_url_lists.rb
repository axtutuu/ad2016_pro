class UrlLists < ActiveRecord::Migration[5.0]
  def change
    create_table :url_lists do |t|
      t.string :user
      t.text   :url
      t.string :created_at
    end
  end
end
