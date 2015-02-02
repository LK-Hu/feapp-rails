class V1::SessionsController < Devise::SessionsController  
  def create  
    respond_to do |format|  
      format.html { super }  
      format.json {  
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")  
        #render :status => 200, :json => { :error => "Success" } 
		render json: current_user, status: 200
      }  
    end  
  end  
  def destroy  
    super  
  end  
end  