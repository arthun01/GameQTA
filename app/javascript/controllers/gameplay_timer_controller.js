import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "display", "container" ]
  static values = {
    seconds: Number
  }

  connect() {
    this.remainingSeconds = this.secondsValue
    this.updateDisplay()
    
    // Inicia apenas se houver tempo > 0
    if (this.remainingSeconds > 0) {
      this.timer = setInterval(() => {
        this.tick()
      }, 1000)
    } else {
      this.submitForm()
    }
  }

  disconnect() {
    this.clearTimer()
  }

  clearTimer() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  tick() {
    this.remainingSeconds--
    this.updateDisplay()

    if (this.remainingSeconds <= 0) {
      this.clearTimer()
      this.submitForm()
    }
  }

  updateDisplay() {
    const minutes = Math.floor(Math.max(0, this.remainingSeconds) / 60)
    const seconds = Math.max(0, this.remainingSeconds) % 60
    
    const m = minutes.toString().padStart(2, '0')
    const s = seconds.toString().padStart(2, '0')
    
    if (this.hasDisplayTarget) {
      this.displayTarget.textContent = `${m}:${s}`
    }

    if (this.remainingSeconds <= 10 && this.hasContainerTarget) {
      this.containerTarget.classList.add("animate-pulse")
    }
  }

  submitForm() {
    const form = document.getElementById("evaluation_form")
    if (form) {
      form.requestSubmit()
    }
  }
}
