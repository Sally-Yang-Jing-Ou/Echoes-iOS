class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
    mylatitude = BigDecimal.new(params[:mylatitude]) if params[:mylatitude]
    mylongitude = BigDecimal.new(params[:mylongitude]) if params[:mylongitude]
    messages = (mylatitude && mylongitude) ? @messages.sort { |a,b| a.distance(mylatitude, mylongitude) <=> b.distance(mylatitude, mylongitude) }.take(20) : @messages
    render json: messages, callback: params[:callback]
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    render json: @message, callback: params[:callback]
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created, location: @message, callback: params[:callback]
    else
      render json: @message.errors, status: :unprocessable_entity, callback: params[:callback]
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    if @message.update(message_params)
      head :no_content
    else
      render json: @message.errors, status: :unprocessable_entity, callback: params[:callback]
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy

    head :no_content
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:body, :latitude, :longitude, :radius, :file)
    end
end
