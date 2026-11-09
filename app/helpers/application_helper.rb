module ApplicationHelper
  def default_form_builder
    AccessibleFormBuilder
  end

  def level_image_path(level_or_id)
    id = level_or_id.respond_to?(:id) ? level_or_id.id : level_or_id
    position = Level.order(:id).pluck(:id).index(id)&.+ 1 || id
    name = "ods-#{position}.png"
    File.file?(Rails.root.join("public", name)) ? "/#{name}" : "/logo_qta.png"
  end
end
