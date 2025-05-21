module ButtonHelper
  # Универсальный хелпер для создания кнопок с классическими параметрами
  # options:
  #   :type - тип кнопки (default: "button")
  #   :class - дополнительные CSS классы (default: "btn btn-primary")
  #   :disabled - отключить кнопку (default: false)
  #   :id - id кнопки (default: nil)
  #   :name - имя кнопки (default: nil)
  #   :value - значение кнопки (default: nil)
  def universal_button(text, options = {})
    type = options.fetch(:type, "button")
    classes = options.fetch(:class, "btn btn-primary")
    disabled = options.fetch(:disabled, false)
    id = options[:id]
    name = options[:name]
    value = options[:value]

    button_tag(text, type: type, class: classes, disabled: disabled, id: id, name: name, value: value)
  end
end
