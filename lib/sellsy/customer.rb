require 'multi_json'

module Sellsy
  class Customer
    attr_accessor :id
    attr_accessor :name, :type, :joindate, :email

    def create
      command = {
          'method' => 'Client.create',
          'params' => {
              'third' => {
                  'name' => @name,
                  'joindate' => @joindate,
                  'type' => @type,
                  'email' => @email
              }
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      @id = response['response']['client_id'] if response['response']

      response['status'] == 'success'
    end

    def update

    end

    def self.find(id)
      command = {
          'method' => 'Client.getOne',
          'params' => {
              'clientid' => id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      client = Customer.new

      if response['response']
        value = response['response']['client']
        client.id = value['id']
        client.name = value['name']
        client.joindate = value['joindate']
        client.type = value['type']
      end

      client
    end

    def self.search(params)
      command = {
          'method' => 'Client.getList',
          'params' => params
      }

      response = MultiJson.load(Sellsy::Api.request command)

      clients = []
      if response['response']
        response['response']['result'].each do |key, value|
          client = Customer.new
          client.id = key
          client.name = value['fullName']
          clients << client
        end
      end

      clients
    end

    def self.all
      command = {
          'method' => 'Client.getList',
          'params' => {}
      }

      response = MultiJson.load(Sellsy::Api.request command)

      clients = []
      if response['response']
        response['response']['result'].each do |key, value|
          client = Customer.new
          client.id = key
          client.name = value['fullName']
          clients << client
        end
      end

      clients
    end
  end
end
