require 'sinatra/base'
require 'pry'
require 'json'
require 'sinatra/partial'
require 'mongoid'

module ApiMockServer

  class Endpoint
    include Mongoid::Document

    field :method, type: String
    field :pattern, type: String
    field :response, type: String
    field :status, type: Integer
    field :params, type: Hash

  end

  class App < Sinatra::Base
    # for partial
    #binding.pry
    register Sinatra::Partial

    Mongoid.load!("mongoid.yml")

    set :partial_template_engine, :erb

    # remove it
    require 'seed'

    get "/admin" do
      erb :index
    end

    get "/admin/new" do
      #@route = Endpoint.new
      erb :new
    end

    post "/admin/new" do
      ps ||= {}
      params["params_key"].each_with_index do |params_name, index|
        ps[params_name] = params["params_value"][index]
      end
      @route = Endpoint.create(method: params["method"],
                               pattern: params["pattern"],
                               status: params["status"] || 200,
                               response: params["response"],
                               params: ps)
      erb :show
    end

    get "/admin/:id" do
      @route = Endpoint.find params[:id]
      erb :show
    end

    #Endpoint.each do |endpoint|
      #send(endpoint.method, endpoint.pattern) do
        #content_type :json
        #status endpoint.status
        #endpoint.response
      #end
    #end
  end

end
