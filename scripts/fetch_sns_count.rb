require "./common"
require 'rest-client'
tw = "http://jsoon.digitiminimi.com/twitter/count.json?url=%{url}"
fb = "https://graph.facebook.com/v2.7/?id=%{url}&access_token=339873939691747|T7SIVXJ5Ddn-wfOSnej3g6Cab1Y"
hb = "http://api.b.st-hatena.com/entry.count?url=%{url}"

UrlList.order("id DESC").each do |url|

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

  # user と tweet idも作成する
  p hatena_share
  p (fb_j.present? && fb_j["share"].present? ? fb_j["share"]["share_count"]   : nil)

  SnsCount.create!(
    user:         url.user,
    tweet_id:     url.tweet_id,
    tw_share:     (tw_j.present? ? tw_j["count"] : 0),
    fb_share:     (fb_j.present? && fb_j["share"].present? ? fb_j["share"]["share_count"]   : 0),
    fb_comment:   (fb_j.present? && fb_j["share"].present? ? fb_j["share"]["comment_count"] : 0),
    hatena_share: hatena_share,
    url:          (tw_j.present? ? tw_j["url"] : nil),
    created_at:   url.created_at
  )
  sleep(1)
end
