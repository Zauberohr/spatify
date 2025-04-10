import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "address", "alwaysOpen", "openingTime", "submit"]

  connect() {
    this.updateButtonState()
  }

  updateButtonState() {
    const nameFilled = this.nameTarget.value.trim() !== ""
    const addressFilled = this.addressTarget.value.trim() !== ""
    const alwaysOpenChecked = this.alwaysOpenTarget.checked

    // Check if at least one opening time is present
    const anyOpeningTime = Array.from(this.openingTimeTargets).some(
      input => input.value.trim() !== ""
    )

    const valid = nameFilled && addressFilled && (alwaysOpenChecked || anyOpeningTime)
    this.submitTarget.disabled = !valid
  }
}
