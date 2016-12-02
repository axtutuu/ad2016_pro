require "./common"
require "uri"
require 'hugeurl'

erros = []
no_counts = ["www.instagram.com", "twitter.com", "t.co"]
Tweet.all.each do |t|
  URI.extract(t.tweet, ["http", "https"]).each do |u|
    begin
      new_url = URI.parse(u).to_huge
      break if no_counts.include? new_url.hostname
      break if UrlList.where(hostname: new_url.hostname).present?

      # tweetのidも保存する hostnameも保存する
      UrlList.create!(user: t.user, tweet_id: t.id_str ,hostname: new_url.hostname, url: new_url.to_s, created_at: t.created_at)
    rescue
      erros << u
    end
  end
end

p erros
