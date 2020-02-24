require 'multi_json'

module Sellsy
  class Contact
    attr_accessor :id
    attr_accessor :name, :thirdid, :forename, :email, :position

    def create
      command = {
          'method' => 'Peoples.create',
          'params' => {
              'people' => {
                  'name' => @name,
                  'forename' => @forename,
                  'email' => @email,
                  'position' => @position,
                  'thirdids' => [@thirdid]
              }
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      @id = response['response']['id'] if response['response']

      response['status'] == 'success'
    end

    def self.find(id)
      command = {
          'method' => 'Peoples.getOne',
          'params' => {
              'id' => id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)
      contact = Contact.new

      if response['response']
        value = response['response']
        contact.id = value['id']
      end

      contact
    end

    def get_addresses
      command = {
          'method' => 'Peoples.getAddresses',
          'params' => {
              'id' => id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)
      client = Contact.new

      if response['response']
        value = response['response']
        client.id = value['id']
      end

      client
    end
  end
end
