require 'multi_json'
require 'rest_client'

module Sellsy
  class Api
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def self.authentication_header
      encoded_key = URI::escape(self.configuration.consumer_secret) + "&" + URI::escape(self.configuration.user_secret)
      now = Time.now
      oauth_params = {
          'oauth_consumer_key' => self.configuration.consumer_token,
          'oauth_token' => self.configuration.user_token,
          'oauth_nonce' => Digest::MD5.hexdigest((now.to_i + rand(0..1000)).to_s),
          'oauth_timestamp' => now.to_i.to_s,
          'oauth_signature_method' => 'PLAINTEXT',
          'oauth_version' => '1.0',
          'oauth_signature' => encoded_key
      }

      'OAuth ' + oauth_params.map { |k, v| k + '="' + v + '"' }.join(', ')
    end

    def self.info
      command = {
          :method => 'Infos.getInfos',
          :params => {}
      }

      MultiJson.load(self.request command)
    end

    def self.request(payload, file = nil)
      file_params = file ? {'do_file' => file} : {}

      puts "params : #{payload}"

      RestClient.log = 'stdout'
      RestClient.post('https://apifeed.sellsy.com/0/',
                      {:request => 1, :io_mode => 'json', 'do_in' => payload.to_json, :multipart => true}.merge(file_params),
                      {:authorization => self.authentication_header}) do |resp|
        puts "resp : #{resp.body}"
        resp
      end
    end

    class Configuration
      attr_accessor :consumer_secret
      attr_accessor :consumer_token
      attr_accessor :user_secret
      attr_accessor :user_token

      def initialize
      end
    end
  end
end
