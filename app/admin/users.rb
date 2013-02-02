ActiveAdmin.register User do
  config.sort_order = "id_asc"
  index do
    selectable_column
    column :id
    column :name
    column :email
    column :sign_in_count
    column :last_sign_in_at
    column :last_sign_in_ip
    column "Role", :sortable => 'roles.name' do |user|
      user.roles.first.name.titleize
    end
    default_actions
  end

  form do |f|
    f.inputs "Information" do
      f.input :name
      f.input :email
      f.input :roles
    end
    f.buttons
  end

  controller do
    with_role :admin

    def scoped_collection
      end_of_association_chain.includes(:roles)
    end
  end
  
end
