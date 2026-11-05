class AccessibleFormBuilder < ActionView::Helpers::FormBuilder
  %i[ text_field email_field password_field number_field text_area check_box ].each do |kind|
    define_method(kind) do |attribute, options = {}, *arguments|
      super(attribute, field_options(attribute, options), *arguments) + field_error(attribute)
    end
  end

  def select(attribute, choices = nil, options = {}, html_options = {}, &block)
    super(attribute, choices, options, field_options(attribute, html_options), &block) + field_error(attribute)
  end

  private
    def field_options(attribute, options)
      if object.respond_to?(:errors) && object.errors[attribute].any?
        options.deep_merge(aria: { invalid: true, describedby: [ options.dig(:aria, :describedby), field_id(attribute, :error) ].compact.join(" ") })
      else
        options
      end
    end

    def field_error(attribute)
      if object.respond_to?(:errors) && object.errors[attribute].any?
        @template.tag.span(object.errors[attribute].join(", "), id: field_id(attribute, :error), class: "field-error")
      else
        "".html_safe
      end
    end
end
