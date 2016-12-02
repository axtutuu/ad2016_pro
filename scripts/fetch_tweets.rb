require "./common"
require 'oauth'

consumer_key        = ENV["CONSUMER_KEY"]
consumer_secret     = ENV["CONSUMER_SECRET"]
access_token        = ENV["ACCESS_TOKEN"]
access_token_secret = ENV["ACCESS_TOKEN_SECRET"]

consumer = OAuth::Consumer.new(
  consumer_key,
  consumer_secret,
  site:'https://api.twitter.com/'
)
endpoint = OAuth::AccessToken.new(consumer, access_token, access_token_secret)

users = ENV["USERS"].split(",")

users.each.with_index(1) do |user, i|
  p user

  datetime = true
  max_id = ""
  params = { screen_name: user, count: 200 }

  begin
    # tweet取得
    params.merge!({ max_id: max_id }) unless max_id.empty?
    response = endpoint.get("https://api.twitter.com/1.1/statuses/user_timeline.json?#{params.to_query}")

    # hashの追加
    JSON.parse(response.body).each do |j|
      Tweet.create!( id_str: j["id_str"], tweet: j["text"], user: user,created_at: j["created_at"])
      datetime = DateTime.parse(j["created_at"]) > DateTime.parse("2015-12-31")
      max_id = j["id_str"]
    end

    p max_id
    break unless datetime

  end while JSON.parse(response.body).length > 2

  # ファイルに書き込み
  # File.open("json_#{i}.txt", "a") do |f|
  #   f.puts hash
  # end
end

