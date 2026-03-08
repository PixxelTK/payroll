import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkin", "checkout", "submit", "error"]

  validate() {
    const checkin = this.checkinTarget.value
    const checkout = this.checkoutTarget.value

    if (!checkin || !checkout) return

    if (checkin > checkout) {
      this.submitTarget.disabled = true
      this.errorTarget.classList.remove("hidden")
    } else {
      this.submitTarget.disabled = false
      this.errorTarget.classList.add("hidden")
    }
  }
}