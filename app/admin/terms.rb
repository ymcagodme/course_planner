ActiveAdmin.register Term do
  menu :parent => "Courses"

  form do |f|
    f.inputs "Required" do
      f.input :code
      f.input :year
      f.input :season, :as => :select,
                       :collection => Term::VALID_SEASON
    end
    f.buttons
  end
end
