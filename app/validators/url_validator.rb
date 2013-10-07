class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || ' must be a valid url or be left blank') unless url_valid?(value)
  end

  def url_valid?(url)
    begin
    	url = URI.parse(url)
    	url.host.include? '.' and (url.kind_of?(URI::HTTP) or url.kind_of?(URI::HTTPS))
    rescue
    	false
    end
  end 
end