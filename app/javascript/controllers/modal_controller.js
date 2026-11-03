import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]
  static values = { autoOpen: Boolean }

  connect() {
    if (this.autoOpenValue) this.show()
  }

  open(event) {
    event.preventDefault()
    this.trigger = event.currentTarget
    this.show()
  }

  show() {
    this.trigger ||= document.activeElement
    if (this.panel.open) this.panel.close()
    this.panel.showModal()
    this.panel.querySelector("[data-dialog-heading]")?.focus()
  }

  close() {
    this.panel.close()
    this.trigger?.focus()
  }

  disconnect() {
    this.panel.close()
  }

  get panel() {
    return this.hasDialogTarget ? this.dialogTarget : this.element
  }
}
