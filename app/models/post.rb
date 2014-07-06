class Post < ActiveRecord::Base
  
  @@bitly_api_address
  @@bitly_access_token

  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true

  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings

  before_validation :format_slug

  before_save :render_body

  def format_slug
    self.slug = slug.downcase.gsub(/(')/, '').gsub(/([^a-z0-9])/, '-').gsub(/(--+)/, '-').gsub(/^(-*)|(-*)$/, '') if attribute_present?('slug')
  end

  def render_body
    redcarpet = Redcarpet::Markdown.new HtmlWithGoodies, {fenced_code_blocks: true}
    self.rendered_body = redcarpet.render body
  end

  def publish!
    touch :published_at unless published_at
  end

  def generate_bitly_url
    uri = URI "#{@@bitly_api_address}/v3/user/link_save"
    uri.query = URI.encode_www_form(
      access_token: @@bitly_access_token,
      longUrl: "#{request.scheme}://#{request.host}/#{slug}",
      title: title
    )
    response = Net::HTTP.get_response(uri)
    response.body if response.is_a? Net::HTTPSuccess
  end

  def to_s
    rendered_body || ''
  end

  def link
    if published_at
  	  "/#{slug}"
    else
      "/posts/#{id}"
    end
  end

  def self.bitly_api_address= address
    @@bitly_api_address = address
  end

  def self.bitly_access_token= token
    @@bitly_access_token = token
  end
end