import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  close() {
    this.element.remove()
  }

  backdrop(e) {
    if (e.target === this.element) {
      this.close()
    }
  }

}