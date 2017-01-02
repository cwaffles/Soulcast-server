class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update] #for dev only, disables authenticity checking on create/update

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { head :unprocessable_entity } #return json of matching token rather than show error
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /nearby/SOME_ID_HERE.json
  # GET /nearby/SOME_USELESS_ID_HERE.json?latitude=49.3&longitude=-122.9&radius=0.1&token=....
  def nearby
    if params[:latitude] && params[:longitude] && params[:radius] #check if we're getting extra params
      # make temp device with random token
      @device = Device.new(token: SecureRandom.hex, latitude: params[:latitude], longitude: params[:longitude], radius: params[:radius])
    else #work off of id only
      set_device
    end

    jsonReturn = {nearby: @device.nearbyDeviceCount}
    render json: jsonReturn
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_device
    # @device = Device.find(params[:id]) #default

    # alternate
    # avoid throwing an exception
    # begin
    #   @device = Device.find(params[:id])
    #   if @device.token != params[:token]
    #     @device = Device.find_by_token(params[:token])
    #   end
    # rescue ActiveRecord::RecordNotFound
    #   if params[:token] != nil
    #     @device = Device.find_by_token(params[:token])
    #   end
    # end

    @device = Device.find_by_id(params[:id])
    #params[:token] == nil means we are browsing the page and removing it will make errors
    if params[:token] != nil && (@device == nil || @device.token != params[:token])
      @device = Device.find_by_token(params[:token])
    end

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.require(:device).permit(:token, :latitude, :longitude, :radius)
  end
end
