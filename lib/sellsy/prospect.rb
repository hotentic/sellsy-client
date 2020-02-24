require 'multi_json'

module Sellsy
  class Prospect
    attr_accessor :id, :name, :joindate, :type, :email

    def create
      command = {
          'method' => 'Prospects.create',
          'params' => {
              'third' => {
                  'name' => @name,
                  'joindate' => @joindate,
                  'type' => @type,
                  'email' => @email
              },
              'contact' => {
                  'name' => @name
              }
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      @id = response['response']

      response['status'] == 'success'
    end

    def update
    end


    # def self.find(id)
    #   command = {
    #       'method' => 'Client.getOne',
    #       'params' => {
    #           'clientid' => id
    #       }
    #   }

    #   response = MultiJson.load(Sellsy::Api.request command)

    #   client = Client.new

    #   if response['response']
    #     value = response['response']['client']
    #     client.id = value['id']
    #     client.name = value['name']
    #     client.joindate = value['joindate']
    #     client.type = value['type']
    #   end

    #   return client
    # end

    def self.search(params)
      command = {
          'method' => 'Prospects.getList',
          'params' => params
      }

      response = MultiJson.load(Sellsy::Api.request command)

      prospects = []
      if response['response']
        response['response']['result'].each do |key, value|
          prospect = Prospect.new
          prospect.id = key
          prospect.name = value['fullName']
          prospects << prospect
        end
      end

      prospects
    end

    def self.all
      command = {
          'method' => 'Prospects.getList',
          'params' => {}
      }

      response = MultiJson.load(Sellsy::Api.request command)

      prospects = []
      if response['response']
        response['response']['result'].each do |key, value|
          prospect = Prospect.new
          prospect.id = key
          prospect.name = value['fullName']
          prospects << prospect
        end
      end

      prospects
    end
  end
end
