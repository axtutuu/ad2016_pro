class Tweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string :id_str
      t.string :user
      t.text   :tweet
      t.string :created_at
    end
  end
end
