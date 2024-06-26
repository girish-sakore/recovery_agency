ActiveAdmin.register AllocationDraft do
  before_action :left_sidebar!
  # before_action :check_admin_access

  permit_params :segment, :pool, :branch, :agreement_id, :customer_name, :pro, :bkt, :fos_name, :fos_mobile_no,
                :caller_name, :caller_mo_number, :f_code, :ptp_date, :feedback, :res, :emi_coll, :cbc_coll, :total_coll,
                :fos_id, :mobile, :address, :zipcode, :phone1, :phone2, :loan_amt, :pos, :emi_amt, :emi_od_amt, :bcc_pending,
                :penal_pending, :cycle, :tenure, :disb_date, :emi_start_date, :emi_end_date, :manufacturer_desc, :asset_cat,
                :supplier, :system_bounce_reason, :reference1_name, :reference2_name, :so_name, :ro_name, :all_dt,
                :caller_id, :executive_id

  config.per_page = 50

  form do |f|
    f.inputs do
      if current_admin_user.admin?
        f.semantic_errors
        f.inputs
        f.input :caller, collection: -> { AdminUser.where(role: :caller).pluck(:name, :id) }.call
        f.input :executive, collection: -> { AdminUser.where(role: :executive).pluck(:name, :id) }.call
      else
        # Show only editable fields for callers and executives
        f.input :feedback
        f.input :ptp_date
        f.input :res
        f.input :emi_coll
        f.input :cbc_coll
        f.input :total_coll
      end
    end
    f.actions
  end

  index do
    selectable_column
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

    def check_admin_access
      unless current_admin_user.admin?
        flash[:alert] = "Access denied. Admin only."
        redirect_to admin_dashboard_path
      end
    end

    def scoped_collection
      if current_admin_user.admin?
        super
      elsif current_admin_user.executive?
        super.where(executive_id: current_admin_user.id)
      elsif current_admin_user.caller?
        super.where(caller_id: current_admin_user.id)
      else
        super.none
      end
    end

    def authorized?(action, subject = nil)
      case action
      when :index
        current_admin_user.admin? || current_admin_user.caller? || current_admin_user.executive?
      when :read, :update
        if subject.is_a?(AllocationDraft)
          current_admin_user.admin? || 
          (current_admin_user.caller? && subject.caller_id == current_admin_user.id) || 
          (current_admin_user.executive? && subject.executive_id == current_admin_user.id)
        else
          current_admin_user.admin? || current_admin_user.caller? || current_admin_user.executive?
        end
      else
        current_admin_user.admin?
      end
    end

    def update
      if current_admin_user.admin?
        super
      else
        # Only allow updating of specific fields for callers and executives
        params[:allocation_draft].slice!(:feedback, :ptp_date, :res, :emi_coll, :cbc_coll, :total_coll)
        super
      end
    end

    def permitted_params
      params = super
      unless current_admin_user.admin?
        params[:allocation_draft].slice!(:feedback, :ptp_date, :res, :emi_coll, :cbc_coll, :total_coll)
      end
      params
    end
  end

  # Batch actions
  batch_action :assign_caller, form: {
    caller_id: -> { AdminUser.where(role: :caller).pluck(:name, :id) }
  } do |ids, inputs|
    AllocationDraft.where(id: ids).find_each do |allocation|
      allocation.update(caller_id: inputs[:caller_id])
    end
    redirect_to collection_path, notice: "Caller assigned to selected allocations"
  end

  batch_action :assign_executive, form: {
    executive_id: -> { AdminUser.where(role: :executive).pluck(:name, :id) }
  } do |ids, inputs|
    AllocationDraft.where(id: ids).update_all(executive_id: inputs[:executive_id])
    redirect_to collection_path, notice: "Executive assigned to selected allocations"
  end
  
end
