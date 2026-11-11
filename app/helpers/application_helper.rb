module ApplicationHelper
  def default_form_builder
    AccessibleFormBuilder
  end

  def level_image_path(level_or_id, position: nil)
    id = level_or_id.respond_to?(:id) ? level_or_id.id : level_or_id
    unless position
      @level_image_positions ||= Level.order(:id).pluck(:id).each_with_index.to_h
      position = @level_image_positions[Integer(id, exception: false)]&.+ 1
    end
    name = "ods-#{position}.png"
    File.file?(Rails.root.join("public", name)) ? "/#{name}" : "/logo_qta.png"
  end
end
