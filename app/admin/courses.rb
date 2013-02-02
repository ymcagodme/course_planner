ActiveAdmin.register Course do
  menu :parent => "Courses"
  filter :number, :label => "class number"
  filter :title
  filter :instructor
  filter :status, :as => :check_boxes, :collection => proc {Course::VALID_STATUS}
  filter :available_seats
  filter :created_at
  filter :updated_at
  filter :term

  config.sort_order = "updated_at_desc"

  index do
    selectable_column
    column :number
    column :title
    column :instructor
    column :status
    column "Seats", :available_seats
    column :term
    default_actions
  end

  form do |f|
    f.inputs "Required" do
      f.input :number
      f.input :title
      f.input :status, :as => :select,
                       :collection => Course::VALID_STATUS
    end
    f.inputs "Optional" do
      f.input :term
      f.input :instructor
      f.input :available_seats
    end
    f.buttons
  end

  sidebar :help do
    "Need help?"
  end
end
