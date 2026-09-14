import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.boundHandleKeydown = this.handleKeydown.bind(this)
  }

  open(event) {
    event.preventDefault()
    this.dialogTarget.classList.remove("hidden")
    document.addEventListener("keydown", this.boundHandleKeydown)
    document.body.style.overflow = "hidden"
  }

  close(event) {
    if (event) event.preventDefault()
    this.dialogTarget.classList.add("hidden")
    document.removeEventListener("keydown", this.boundHandleKeydown)
    document.body.style.overflow = ""
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}

