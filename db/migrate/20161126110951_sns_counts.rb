class SnsCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :sns_counts do |t|
      t.text    :url
      t.integer :fb_share
      t.integer :fb_comment
      t.integer :tw_share
      t.integer :hatena_share
      t.string  :created_at
    end
  end
end
