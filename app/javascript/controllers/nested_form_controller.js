import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nested-form"
export default class extends Controller {
  static targets = ["template", "target"]

  add(e) {
    e.preventDefault()

    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, crypto.randomUUID())
    this.targetTarget.insertAdjacentHTML('beforeend', content)
    this.targetTarget.lastElementChild.querySelector("input[type=text]")?.focus()
  }

  remove(e) {
    e.preventDefault()
    
    const wrapper = e.target.closest('.nested-fields')
    this.element.querySelector('[data-action="nested-form#add"]')?.focus()
    if (wrapper.dataset.newRecord === 'true') {
      wrapper.remove()
    } else {
      wrapper.querySelector("input[name*='_destroy']").value = 1
      wrapper.style.display = 'none'
    }
  }

  selectCorrect(e) {
    const wrapper = this.element
    const radios = wrapper.querySelectorAll('.is-correct-radio')
    radios.forEach(radio => {
      if (radio !== e.target) {
        radio.checked = false
      }
    })
  }
}
