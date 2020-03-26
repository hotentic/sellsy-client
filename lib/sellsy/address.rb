require 'multi_json'

module Sellsy
  class Address
    attr_accessor :id, :name, :address, :postal_code, :town, :country, :linkedid, :linkedtype

    def create
      command = {
          'method' => 'Addresses.create',
          'params' => to_params
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
        address.address = [value['part1'], value['part2'] || ''].select {|p| !p.blank?}.join("\n")
        address.town = value['town']
        address.country = value['countrycode'].downcase unless value['countrycode'].blank?
        address.linkedid = value['linkedid']
        address.linkedtype = value['linkedtype']
        address.postal_code = value['zip']
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
          address.address = [value['part1'] || '', value['part2'] || ''].select {|p| !p.blank?}.join("\n")
          address.town = value['town']
          address.country = value['countrycode'].downcase unless value['countrycode'].blank?
          address.linkedid = value['linkedid']
          address.linkedtype = value['linkedtype']
          address.postal_code = value['zip']
          addresses << address
        end
      end

      addresses
    end

    def to_params
      {
        'name' => 'Adresse principale',
        'part1' => @address.split(/(\r\n?)/)[0],
        'part2' => @address.split(/(\r\n?)/)[1],
        'zip' => @postal_code,
        'town' => @town,
        'countrycode' => @country.upcase,
        "linkedtype" => linkedtype,
        "linkedid" => linkedid
      }
    end
  end
end
