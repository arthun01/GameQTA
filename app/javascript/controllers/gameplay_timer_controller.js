import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "announcement"]
  static values = { deadline: String, serverNow: String, warning: String }

  connect() {
    this.deadline ||= performance.now() + Date.parse(this.deadlineValue) - Date.parse(this.serverNowValue)
    this.tick()
    if (this.deadline > performance.now()) this.timer = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    const remaining = Math.max(0, Math.ceil((this.deadline - performance.now()) / 1000))
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
