require 'net/http'
require 'uri'

class GooglePlaylist
  COOKIE_URL = 'https://play.google.com/music/listen'.freeze
  URL = 'https://play.google.com/music/services/createplaylist'.freeze
  USER_AGENT = 'Music Manager (1, 0, 55, 7425 HTTPS - Windows)'.freeze

  attr_accessor :name, :description, :is_public, :access_token, :cookie, :error

  def initialize attributes={}
    attributes.each {|k, v| send("#{k}=", v) }
    @is_public = @is_public == 'true'
    @error = {}
  end

  def create
    uri = URI.parse(URL + '?format=jsarray')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    data = {
      'u' => 0,
      'xt' => @cookie,
      'create' => {
        'creationTimestamp' => '-1',
        'deleted' => false,
        'lastModifiedTimestamp' => '0',
        'name' => @name,
        'type' => 'USER_GENERATED',
        'accessControlled' => !@is_public
      }
    }
    request.set_form_data(data)
    request['User-agent'] = USER_AGENT
    request['Authorization'] = 'GoogleLogin auth=%s' % @access_token
    http.request(request)
  end

  def set_cookie
    uri = URI(COOKIE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Head.new(uri.path)
    request['Authorization'] = 'GoogleLogin auth=%s' % @access_token
    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      puts 'cookie succeeded'
      @cookie = response.to_hash['set-cookie'].
                         map {|e| e =~ /^xt=([^;]+);/ and $1 }.compact.first
    else
      puts 'cookie failed'
      puts response.code
      puts response.body
    end
    response
  end
end
