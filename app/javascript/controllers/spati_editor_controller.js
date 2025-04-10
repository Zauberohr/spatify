import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "mapContainer", "editButton", "form", "display"]
  static values = { editing: Boolean }

  connect() {
    this.updateStyle()
  }

  toggleEdit() {
    if (this.editingValue) {
      // Im Bearbeitungsmodus → Formular abschicken
      const form = this.cardTarget.querySelector("form")
      if (form) form.requestSubmit()
    } else {
      this.enterEdit()
    }
  }

  enterEdit() {
    this.editingValue = true
    this.updateStyle()

    if (this.hasFormTarget) this.formTarget.hidden = false
    if (this.hasDisplayTarget) this.displayTarget.hidden = true

    if (this.hasEditButtonTarget) {
      this.editButtonTarget.textContent = "Späti speichern"
      this.editButtonTarget.classList.add("save-button")
      this.editButtonTarget.classList.remove("späti-button")
    }
  }

  exitEdit() {
    this.editingValue = false
    this.updateStyle()

    if (this.hasFormTarget) this.formTarget.hidden = true
    if (this.hasDisplayTarget) this.displayTarget.hidden = false

    if (this.hasEditButtonTarget) {
      this.editButtonTarget.textContent = "Späti bearbeiten"
      this.editButtonTarget.classList.remove("save-button")
      this.editButtonTarget.classList.add("späti-button")
    }
  }

  updateStyle() {
    if (this.editingValue) {
      this.cardTarget.classList.add("edit-mode")
      this.mapContainerTarget.classList.add("edit-mode")
    } else {
      this.cardTarget.classList.remove("edit-mode")
      this.mapContainerTarget.classList.remove("edit-mode")
    }
  }
}
