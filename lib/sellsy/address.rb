require 'multi_json'

module Sellsy
  class Address
    attr_accessor :id
    attr_accessor :part1, :town, :country_code, :linkedid, :linkedtype, :zip, :name

    def create
      params = {
          "name" => name,
          "linkedtype" => linkedtype,
          "linkedid" => linkedid,
          "part1" => part1,
          "zip" => zip,
          "town" => town,
          "countrycode" => country_code,
      }

      command = {
          'method' => 'Addresses.create',
          'params' => params
      }

      response = MultiJson.load(Sellsy::Api.request command)

      @id = response['response']['address_id'] if response['response']

      response['status'] == 'success'
    end

    def self.find(id)
      command = {
          'method' => 'Addresses.getOne',
          'params' => {
              'id' => id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)
      address = Address.new

      if response['response']
        value = response['response']
        address.id = key
        address.part1 = value['part1']
        address.town = value['town']
        address.country_code = value['countrycode']
        address.linkedid = value['linkedid']
        address.linkedtype = value['linkedtype']
        address.zip = value['zip']
      end

      address
    end

    def self.all
      command = {
          'method' => 'Addresses.getList',
          'params' => {}
      }

      response = MultiJson.load(Sellsy::Api.request command)

      addresses = []

      if response['response']
        response['response']['result'].each do |key, value|
          address = Address.new
          address.id = key
          address.part1 = value['part1']
          address.town = value['town']
          address.country_code = value['countrycode']
          address.linkedid = value['linkedid']
          address.linkedtype = value['linkedtype']
          address.zip = value['zip']
          addresses << address
        end
      end

      addresses
    end
  end
end
