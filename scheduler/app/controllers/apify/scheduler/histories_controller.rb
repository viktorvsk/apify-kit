module Apify::Scheduler
  class HistoriesController < ApplicationController
    layout 'apify/scheduler/application'
    before_action :set_history, only: [:destroy]

    # GET /histories
    def index
      @unit = Unit.find(params[:unit_id])
      @histories = @unit.histories.order('created_at DESC')
    end

    # DELETE /histories/1
    def destroy
      @history.destroy
      redirect_to :back, notice: 'History was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_history
        @history = History.find(params[:id])
      end
  end
end
