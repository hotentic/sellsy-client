require 'multi_json'

module Sellsy
  class CustomField
    attr_accessor :id, :value

    def initialize(id, value)
      @id = id
      @value = value
    end

    def self.set_values(entity, *custom_fields)
      command = {
          'method' => 'CustomFields.recordValues',
          'params' => {
              'linkedtype' => linked_type(entity),
              'linkedid' => entity.id,
              'values' => custom_fields.select {|cf| !cf.nil? && !cf.value.blank?}.map {|cf| {'cfid' => cf.id, 'value' => cf.value}}
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      response['status'] == 'success'
    end

    def self.linked_type(entity)
      case entity
      when Customer
        'client'
      when Prospect
        'prospect'
      when Opportunity
        'opportunity'
      when Contact
        'people'
      when Document
        'document'
      else
        nil
      end
    end

    def self.all
      command = {
          'method' => 'CustomFields.getList',
          'params' => {
              'pagination' => {
                  'nbperpage' => 30
              }
          }
      }
      response = MultiJson.load(Sellsy::Api.request command)

      response['status'] == 'success' ? response['response']['result'] : {}
    end
  end
end