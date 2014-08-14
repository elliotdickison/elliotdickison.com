get '/webmention' do

	# Make sure we got a target and a source
	halt 400, "Target URL not found." unless params[:target]
	halt 400, "Source URL not found." unless params[:source]

	# Parse the target URL
	params[:target] = "//#{params[:target]}" unless params[:target].include? '//'
	target = URI(params[:target])
	halt 400, "Invalid Target: Does not belong to #{target.host}" unless target.host == request.host

	# Find the blog post referred to by the target
	post = Post.find_by slug: target.path.gsub(/^[\/\s]+|[\/\s]+$/, '')
	halt 400, "Invalid Target: Did not resolve to a blog post" unless post
	
	# Curl the source
	source = Curl::Easy.perform params[:source] { |curl| curl.follow_location = true }
	halt 400, "Unreachable Source: #{source.response_code}" unless source.response_code < 400
	halt 400, "Non-Textual Source: #{source.content_type}" unless source.content_type.include? 'text'
	
	# Ensure that the target is mentioend by the source
	halt 400, "False Mention: The source does not mention the target" unless source.body_str.include? params[:target]

	source_html = Nokogiri::HTML source.body_str
end