ActiveAdmin.register AllocationDraft do
  before_action :left_sidebar!
  
  # permit_params :segment, :pool, :branch, :agreement_id, :customer_name, :pro, :bkt, :fos_name, :fos_mobile_no,
  #               :caller_name, :caller_mo_number, :f_code, :ptp_date, :feedback, :res, :emi_coll, :cbc_coll, :total_coll,
  #               :fos_id, :mobile, :address, :zipcode, :phone1, :phone2, :loan_amt, :pos, :emi_amt, :emi_od_amt, :bcc_pending,
  #               :penal_pending, :cycle, :tenure, :disb_date, :emi_start_date, :emi_end_date, :manufacturer_desc, :asset_cat,
  #               :supplier, :system_bounce_reason, :reference1_name, :reference2_name, :so_name, :ro_name, :all_dt,
  # permit_params :file
  index do
    selectable_column
    id_column
    columns = current_admin_user.user_preference&.column_preferences || AllocationDraft.column_names
    columns.each do |column|
      column column.to_sym
    end
    actions
  end

  sidebar :column_preferences, priority: 0, only: :index do
    render 'admin/allocation_drafts/column_preferences_form'
  end

  # Action Items
  action_item :only => :index do
    link_to 'Upload EXCEL SHEET', :action => 'import_excel'
  end

  # Actions
  collection_action :import_excel do
    
  end

  collection_action :import_allocation, :method => :post do
    file_path = params[:file]
    errors, success = ImportAllocationService.new(file_path).import
    # respond_to do |format|
    #   format.html do
    #     if errors.empty?
    #       flash[:notice] = "Data imported successfully!"
    #     else
    #       flash[:alert] = " errors: #{errors} "
    #     end
    #     redirect_to :action => :index
    #   end
    #   format.all do
        render json: { success: success, errors: errors, redirect_url: admin_allocation_drafts_url }
      # end
    # end   
  end

  collection_action :save_column_preferences, method: :post do
    user_preference = current_admin_user.user_preference || UserPreference.new(admin_user_id: current_admin_user.id)
    user_preference.column_preferences = params[:columns]
    if user_preference.save
      redirect_to admin_allocation_drafts_path, notice: "Column preferences saved!"
    else
      redirect_to admin_allocation_drafts_path, alert: "Failed to save column preferences."
    end
  end

  # Controller
  controller do
    skip_before_action :verify_authenticity_token, only: :import_allocation
  end
  
end
