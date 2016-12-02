require "./common"
require "uri"
require 'hugeurl'

since_id = 18440
erros = []
no_counts = ["www.instagram.com", "twitter.com", "t.co"]
black_lists = ["https://t.co/FgSWfk3Ytp", "https://t.co/unWnK1ZdJZ", "https://t.co/KoovlcqGfG", "https://t.co/lBMpSaZ2JR", "https://t.co/R6I21tMNVf"]
# tweetを途中から取得出来たほうが良い
Tweet.where("id > ?", since_id).each do |t|
# Tweet.all.each do |t|
  URI.extract(t.tweet, ["http", "https"]).each do |u|
    begin
      p t.id_str
      p u
      break if black_lists.include? u # expandエラーになるものをスキップ
      new_url = URI.parse(u).to_huge
      break if no_counts.include? new_url.hostname
      break if UrlList.where(hostname: new_url.hostname).present?

      UrlList.create!(user: t.user, tweet_id: t.id_str ,hostname: new_url.hostname, url: new_url.to_s, created_at: t.created_at)
    rescue
      erros << u
    end
  end
end

