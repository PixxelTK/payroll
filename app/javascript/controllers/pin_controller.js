import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden"]

  connect() {
    if (this.inputTargets.length > 0) {
      this.inputTargets[0].focus()
    }
  }

  input(event) {
    const input = event.target
    const index = this.inputTargets.indexOf(input)

    input.value = input.value.replace(/[^0-9]/g, "")

    if (input.value.length === 1 && index < this.inputTargets.length - 1) {
      this.inputTargets[index + 1].focus()
    }

    this.updatePin()
  }

  keydown(event) {
    const input = event.target
    const index = this.inputTargets.indexOf(input)

    if (event.key === "Backspace" && !input.value && index > 0) {
      this.inputTargets[index - 1].focus()
    }
  }

  updatePin() {
    this.hiddenTarget.value = this.inputTargets.map(i => i.value).join("")
  }
}