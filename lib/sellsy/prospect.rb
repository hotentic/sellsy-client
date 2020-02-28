require 'multi_json'

module Sellsy
  class Prospect

    attr_accessor :id, :title, :name, :first_name, :last_name, :structure_name, :category, :college_type, :siret,
                  :ape, :legal_type, :role, :birth_date, :address, :postal_code, :town, :country, :telephone, :email,
                  :website, :payment_method, :person_type, :apidae_member_id

    def create
      command = {
          'method' => 'Prospects.create',
          'params' => api_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      @id = response['response']
      response['status'] == 'success'
    end

    def update
      command = {
          'method' => 'Prospects.update',
          'params' => api_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      response['status'] == 'success'
    end

    def api_params
      {
          'third' => {
              'name' => person_type == 'pp' ? @name : @structure_name,
              'type' => person_type == 'pp' ? 'person' : 'corporation',
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
              'name' => 'adresse souscription',
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
