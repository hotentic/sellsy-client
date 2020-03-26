require 'multi_json'

module Sellsy
  class Customer
    attr_accessor :id, :name, :structure_name, :category, :college_type, :siret, :ape, :legal_type, :email,
                  :website, :payment_method, :person_type, :apidae_member_id, :main_contact_id, :contact, :address,
                  :contacts

    def create
      command = {
          'method' => 'Client.create',
          'params' => to_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      @id = response['response']
      response['status'] == 'success'
    end

    def update
      command = {
          'method' => 'Client.update',
          'params' => to_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      response['status'] == 'success'
    end

    def to_params
      {
          'id' => @id,
          'third' => {
              'name' => person_type == 'pp' ? @name : @structure_name,
              'type' => person_type == 'pp' ? 'person' : 'corporation',
              'ident' => apidae_member_id,
              'email' => @email,
              'web' => @website,
              'siret' => @siret,
              'corpType' => @legal_type,
              'apenaf' => @ape
          },
          'contact' => contact ? contact.to_params : {},
          'address' => address ? address.to_params : {}
      }
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
        client.type = value['type']
        client.contacts = response['response']['contacts']
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
