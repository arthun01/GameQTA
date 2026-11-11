import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["choices", "player", "stop"]
  static values = { url: String, title: String }

  load() {
    const frame = document.createElement("iframe")
    frame.src = this.urlValue
    frame.title = this.titleValue
    frame.className = "w-full aspect-video"
    frame.allowFullscreen = true
    frame.referrerPolicy = "strict-origin-when-cross-origin"
    this.playerTarget.replaceChildren(frame)
    this.choicesTarget.hidden = true
    this.stopTarget.hidden = false
    this.stopTarget.focus()
  }

  reset() {
    this.playerTarget.replaceChildren()
    this.choicesTarget.hidden = false
    this.stopTarget.hidden = true
    this.choicesTarget.querySelector("button").focus()
  }

  disconnect() {
    this.playerTarget.replaceChildren()
  }
}
