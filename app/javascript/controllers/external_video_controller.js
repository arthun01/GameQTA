import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["choices", "status", "player", "stop", "rejection"]
  static values = { url: String, title: String }

  load() {
    const frame = document.createElement("iframe")
    frame.src = this.urlValue
    frame.title = this.titleValue
    frame.className = "w-full aspect-video"
    frame.allowFullscreen = true
    frame.referrerPolicy = "strict-origin-when-cross-origin"
    this.playerTarget.replaceChildren(frame)
    this.statusTarget.textContent = ""
    this.choicesTarget.hidden = true
    this.stopTarget.hidden = false
    this.stopTarget.focus()
  }

  reject() {
    this.statusTarget.textContent = this.rejectionTarget.textContent
  }

  reset() {
    this.playerTarget.replaceChildren()
    this.choicesTarget.hidden = false
    this.stopTarget.hidden = true
    this.statusTarget.textContent = ""
    this.choicesTarget.querySelector("button").focus()
  }

  disconnect() {
    this.playerTarget.replaceChildren()
  }
}
