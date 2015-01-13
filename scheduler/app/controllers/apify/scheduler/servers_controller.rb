module Apify
  module Scheduler
    class ServersController < ApplicationController
      layout 'apify/scheduler/application'
      before_action :set_server, only: [:show, :edit, :update, :destroy, :test]

      # GET /servers
      def index
        @servers = Apify::Scheduler::Server.all
      end

      # GET /servers/1
      def show
      end

      # GET /servers/new
      def new
        @server = Apify::Scheduler::Server.new
      end

      # GET /servers/1/edit
      def edit
      end

      def test
        response  = @server.test_api_key
        message   = response['message']
        flash_key = response['status'] == '1' ? :notice : :error

        redirect_to servers_path, flash: { flash_key => message }
      end

      # POST /servers
      def create
        @server = Apify::Scheduler::Server.new(server_params)

        if @server.save
          redirect_to @server, notice: 'Server was successfully created.'
        else
          render :new
        end
      end

      # PATCH/PUT /servers/1
      def update
        if @server.update(server_params)
          redirect_to @server, notice: 'Server was successfully updated.'
        else
          render :edit
        end
      end

      # DELETE /servers/1
      def destroy
        @server.destroy
        redirect_to servers_url, notice: 'Server was successfully destroyed.'
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_server
          @server = Apify::Scheduler::Server.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def server_params
          params.require(:server).permit(:name, :url, :description, :api_key)
        end
    end
  end
end
