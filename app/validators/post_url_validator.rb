class PostUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'Адрес должен быть вида https://vk.com/wall-***********_**') unless url_valid?(value)
  end

  def url_valid?(url)
    uri = URI.parse(url) rescue false
    uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
  end
end