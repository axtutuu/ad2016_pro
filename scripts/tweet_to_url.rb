require "./common"
require "uri"
require 'hugeurl'

erros = []
no_counts = ["www.instagram.com", "twitter.com"]
Tweet.all.each do |t|
  URI.extract(t.tweet, ["http", "https"]).each do |u|
    begin
      new_url = URI.parse(u).to_huge
      break if no_counts.include? new_url.hostname
      break if UrlList.where(url: new_url.to_s).present?
      # 無効urlだったら作成しない

      # tweetのidも保存する
      p new_url.to_s
      UrlList.create!(user: t.user, url: new_url.to_s, created_at: t.created_at)
    rescue
      erros << u
    end
  end
end

p erros
