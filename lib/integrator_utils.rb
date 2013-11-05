require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'active_support/core_ext/hash'
require 'multi_json'
require 'exceptional'

module Sinatra
  module IntegratorUtils

    module Helpers
      def config(message)
        conf = []
        if message[:payload].kind_of?(Hash) && message[:payload]['parameters']
          conf = message[:payload]['parameters']
        end

        conf.inject(HashWithIndifferentAccess.new) do |result, param|
          result[param[:name]] = param[:value]
          result
        end
      end

      def process_result(code, response)
        status code
        json response
      end
    end

    def self.registered(app)

      app.helpers Sinatra::JSON
      app.helpers IntegratorUtils::Helpers

      app.set :public_folder, './public'

      app.before do
        if request.get? && request.path_info == '/'
          redirect '/endpoint.json'
        elsif request.get? && ENV['PUBLIC_PATHS'].split(';').include?(request.path_info)
          # DD: proceed as usual
        else
          begin
            # DD: for debugging
            ENV['ENDPOINT_KEY'] ||= ""
            header = request.env["HTTP_X_AUGURY_TOKEN"] || ""
            raise "Augury token did not match. Found: '#{request.env["HTTP_X_AUGURY_TOKEN"]}'" if header != ENV['ENDPOINT_KEY']
          rescue Exception => e
            ::Exceptional::Catcher.handle(e)
            halt 401
          end
        end

        if request.post?
          begin
            @message = ::JSON.parse(request.body.read).with_indifferent_access
            @config = config(@message)
          rescue Exception => e
            # DD: let's exception raise in dev and gracefully fail in production
            # useful: http://support.exceptional.io/discussions/questions/352-correct-way-to-manually-send-an-exception
            ::Exceptional::Catcher.handle(e)
            halt 406
          end
        end
      end

      app.get '/auth' do
        status 200
      end
    end

  end

  register IntegratorUtils
end
