require 'multi_json'

module Sellsy
  class Customer
    attr_accessor :id, :title, :name, :first_name, :last_name, :structure_name, :category, :college_type, :siret,
                  :ape, :legal_type, :role, :birth_date, :address, :postal_code, :town, :country, :telephone, :email,
                  :website, :payment_method, :person_type, :apidae_member_id, :main_contact_id

    def create
      command = {
          'method' => 'Client.create',
          'params' => api_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      @id = response['response']
      response['status'] == 'success'
    end

    def update
      command = {
          'method' => 'Client.update',
          'params' => api_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      response['status'] == 'success'
    end

    def api_params
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
          'contact' => {
              'civil' => civil_enum(@title),
              'name' => @last_name || @name,
              'forename' => @first_name,
              'email' => @email,
              'tel' => @telephone,
              'mobile' => @telephone,
              'position' => @role,
          },
          'address' => {
              'name' => 'Adresse principale',
              'part1' => @address.split(/(\r\n?)/)[0],
              'part2' => @address.split(/(\r\n?)/)[0],
              'zip' => @postal_code,
              'town' => @town,
              'countrycode' => @country.upcase
          }
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
        client.joindate = value['joindate']
        client.type = value['type']
        client.main_contact_id = value['maincontactid']
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

    private

    def civil_enum(val)
      case val
      when 'M.'
        'man'
      when 'Mme'
        'woman'
      else
        nil
      end
    end
  end
end
