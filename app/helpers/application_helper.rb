module ApplicationHelper
  def default_form_builder
    AccessibleFormBuilder
  end

  def level_image_path(level_id)
    name = "ods-#{level_id}.png"
    File.file?(Rails.root.join("public", name)) ? "/#{name}" : "/logo_qta.png"
  end
end
