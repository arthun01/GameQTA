import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "announcement"]
  static values = { seconds: Number, warning: String }

  connect() {
    this.deadline = Date.now() + this.secondsValue * 1000
    this.tick()
    if (this.secondsValue > 0) this.timer = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    const remaining = Math.max(0, Math.ceil((this.deadline - Date.now()) / 1000))
    this.displayTarget.textContent = `${Math.floor(remaining / 60).toString().padStart(2, "0")}:${(remaining % 60).toString().padStart(2, "0")}`
    if (remaining <= 20 && !this.warned) {
      this.announcementTarget.textContent = this.warningValue
      this.warned = true
    }
    if (remaining === 0) {
      clearInterval(this.timer)
      document.getElementById("evaluation_form")?.requestSubmit()
    }
  }
}
