module Apify
  module Scheduler
    class UnitsController < ApplicationController

      layout 'apify/scheduler/application'
      before_action :set_unit, only: [:show, :edit, :update, :destroy, :perform]


      # GET /units
      def index
        @units = Apify::Scheduler::Unit.all
      end

      # GET /units/1
      def show
      end

      # GET /units/new
      def new
        @unit = Apify::Scheduler::Unit.new
      end

      # GET /units/1/edit
      def edit
      end

      # POST /units
      def create
        @unit = Apify::Scheduler::Unit.new(unit_params)

        if @unit.save
          redirect_to @unit, notice: 'Unit was successfully created.'
        else
          render :new
        end
      end

      # PATCH/PUT /units/1
      def update
        if @unit.update(unit_params)
          redirect_to @unit, notice: 'Unit was successfully updated.'
        else
          render :edit
        end
      end

      # POST /units/1/perform
      def perform
        worker = @unit.enqueue
        message   = worker ? "Successfully added #{@unit.name} unit to queue. Refresh page to see progress." : "Error occured while queuing #{@unit.name}. Try again"
        flash_key = worker ? :notice : :error
        redirect_to units_path, flash: { flash_key => message }
      end

      # DELETE /units/1
      def destroy
        @unit.destroy
        redirect_to units_url, notice: 'Unit was successfully destroyed.'
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_unit
          @unit = Apify::Scheduler::Unit.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def unit_params
          params.require(:unit).permit( :name, :description, :pattern,
                                        :processes, :delay, :destination,
                                        :apify_scheduler_server_id, :apify_scheduler_frequency_period_id,
                                        :frequency_quantity, :at)
        end

    end
  end
end
