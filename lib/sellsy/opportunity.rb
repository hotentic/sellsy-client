require 'multi_json'

module Sellsy
  class Opportunity
    attr_accessor :id, :name, :reference, :amount, :entity_type, :entity_id, :source_name, :funnel_name, :step_name,
                  :comments

    def create
      command = {
          'method' => 'Opportunities.create',
          'params' => api_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      @id = response['response']
      response['status'] == 'success'
    end

    def update
      command = {
          'method' => 'Opportunities.update',
          'params' => api_params
      }

      response = MultiJson.load(Sellsy::Api.request command)
      response['status'] == 'success'
    end

    def get_funnel
      command = {'method' => 'Opportunities.getFunnels', 'params' => {}}
      response = MultiJson.load(Sellsy::Api.request command)

      funnel = nil
      unless response['response'].blank? || funnel_name.blank?
        funnel = response['response'].values.find {|f| f['name'].parameterize == funnel_name.parameterize}
      end
      funnel
    end

    def get_step(funnel_id)
      command = {'method' => 'Opportunities.getStepsForFunnel', 'params' => {'funnelid' => funnel_id}}
      response = MultiJson.load(Sellsy::Api.request command)

      step = [nil]
      unless response['response'].blank? || step_name.blank?
        step = response['response'].find {|s| s['label'].parameterize == step_name.parameterize}
      end
      step
    end

    def get_source
      command = {'method' => 'Opportunities.getSources', 'params' => {}}
      response = MultiJson.load(Sellsy::Api.request command)

      source = nil
      unless response['response'].blank? || source_name.blank?
        source = response['response'].values.find {|s| s['label'].parameterize == source_name.parameterize}
      end
      source
    end

    def api_params
      funnel = get_funnel
      step = get_step(funnel['id'])
      source = get_source
      if funnel && step && source
        {
            'opportunity' => {
                'linkedtype' => @entity_type,
                'linkedid' => @entity_id,
                'ident' => @reference,
                'sourceid' => source['id'],
                'name' => @name,
                'potential' => @amount,
                'funnelid' => funnel['id'],
                'dueDate' => (Date.today + 1.month).to_datetime.to_i,
                'stepid' => step['id']
            }
        }
      else
        raise Exception.new("Could not find funnel, step, or source with names #{funnel_name} - #{step_name} - #{source_name}")
      end
    end

    def self.find(id)
      command = {
          'method' => 'Opportunities.getOne',
          'params' => {
              'id' => id
          }
      }

      response = MultiJson.load(Sellsy::Api.request command)

      opportunity = Opportunity.new

      if response['response']
        value = response['response']['opportunity']
        opportunity.id = value['id']
        opportunity.name = value['name']
      end

      return opportunity
    end

    def self.search(params)
      command = {
          'method' => 'Opportunities.getList',
          'params' => params
      }

      response = MultiJson.load(Sellsy::Api.request command)

      opportunities = []
      if response['response']
        response['response']['result'].each do |key, value|
          opportunity = Opportunity.new
          opportunity.id = key
          opportunity.status = value['status']
          opportunity.name = value['name']
          opportunity.ident = value['ident']
          opportunity.signed = value['signed']
          opportunity.linkedid = value['linkedid']
          opportunities << opportunity
        end
      end

      opportunities
    end

    def self.all
      command = {
          'method' => 'Opportunities.getList',
          'params' => {}
      }

      response = MultiJson.load(Sellsy::Api.request command)

      opportunities = []
      if response['response']
        response['response']['result'].each do |key, value|
          opportunity = Opportunity.new
          opportunity.id = key
          opportunity.status = value['status']
          opportunity.name = value['name']
          opportunity.ident = value['ident']
          opportunity.signed = value['signed']
          opportunity.linkedid = value['linkedid']
          opportunities << opportunity
        end
      end

      opportunities
    end
  end
end
