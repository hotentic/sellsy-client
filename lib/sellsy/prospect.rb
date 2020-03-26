require 'multi_json'

module Sellsy
  class Prospect
    attr_accessor :id, :name, :structure_name, :category, :college_type, :siret, :ape, :legal_type, :email,
                  :website, :payment_method, :person_type, :apidae_member_id, :main_contact_id, :contact, :address,
                  :contacts

    def create
      command = {
          'method' => 'Prospects.create',
          'params' => to_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      @id = response['response']
      response['status'] == 'success'
    end

    def update
      command = {
          'method' => 'Prospects.update',
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
          'method' => 'Prospects.getOne',
          'params' => {
              'id' => id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      prospect = Prospect.new

      if response['response']
        value = response['response']['client']
        prospect.id = value['id']
        prospect.name = value['name']
        prospect.contacts = response['response']['contacts']
      end

      return prospect
    end

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
