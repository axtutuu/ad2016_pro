require "./common"
require 'rest-client'
tw = "http://jsoon.digitiminimi.com/twitter/count.json?url=%{url}"
fb = "http://graph.facebook.com/?id=%{url}"
hb = "http://api.b.st-hatena.com/entry.count?url=%{url}"

UrlList.all.each do |url|

  tw_res = RestClient.get(tw% {url: url.url})
  tw_j = JSON.parse(tw_res) if tw_res.present?

  begin
    fb_res = RestClient.get(fb% {url: url.url})
    fb_j  = JSON.parse(fb_res) if fb_res.present?
  rescue => e
    p e
  end

  hatena_res = RestClient.get(hb% {url: url.url})
  hatena_share = JSON.parse(hatena_res) if hatena_res.present?

  p hatena_share
  SnsCount.create!(
    tw_share:     (tw_j.present? ? tw_j["count"] : nil),
    fb_share:     (fb_j.present? && fb_j["share"].present? ? fb_j["share"]["share_count"]   : nil),
    fb_comment:   (fb_j.present? && fb_j["share"].present? ? fb_j["share"]["comment_count"] : nil),
    hatena_share: hatena_share,
    url:          (tw_j.present? ? tw_j["url"] : nil),
    created_at:   url.created_at
  )
  sleep(1)
end
