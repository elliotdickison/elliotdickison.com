xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "elliotjam.es"
    xml.description "Elliot's Bloorg"
    xml.link "#{request.scheme}://#{request.host}/blog"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link "#{request.scheme}://#{request.host}/#{post.link}"
        xml.description post.body
        xml.pubDate Time.parse(post.published_at.to_s).rfc822()
        xml.guid "#{request.scheme}://#{request.host}/#{post.link}"
      end
    end
  end
end