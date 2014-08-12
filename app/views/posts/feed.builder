xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Elliot Dickison"
    xml.description "A sorta web development blog."
    xml.link "#{request.scheme}://#{request.host}/blog"

    @posts.each do |post|

      # Convert markdown to html and replace relative links with absolute ones
      post_body = post.render_body
        .gsub(/(href="\/)/, "href=\"#{request.scheme}://#{request.host}/")
        .gsub(/(href="#)/, "href=\"#{request.scheme}://#{request.host}#{post.link}#")

      xml.item do
        xml.title post.title
        xml.link "#{request.scheme}://#{request.host}#{post.link}"
        xml.description post_body
        xml.pubDate Time.parse(post.published_at.to_s).rfc822()
        xml.guid "#{request.scheme}://#{request.host}#{post.link}"
      end
    end
  end
end