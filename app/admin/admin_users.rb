ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role, :name

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :name
  filter :role
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :name if f.object.new_record? || f.object.caller? || f.object.executive?
      f.input :role, as: :select, collection: AdminUser.roles.keys
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      if params[:admin_user][:password].blank? && params[:admin_user][:password_confirmation].blank?
        params[:admin_user].delete("password")
        params[:admin_user][:password_confirmation]
      end
      super
    end
  end
end
