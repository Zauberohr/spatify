import { Controller } from "@hotwired/stimulus"

// Verbindet sich mit data-controller="form-validation"
export default class extends Controller {
  static targets = ["name", "address", "alwaysOpen", "openingTime", "submit"]

  connect() {
    // Beim Laden des Formulars den Button-Zustand initial setzen
    this.updateButtonState()
  }

  // Diese Methode prüft die Pflichtfelder und schaltet den Button an/aus
  updateButtonState() {
    // Eingabewerte auslesen und trimmen (entfernt Leerzeichen)
    const nameFilled = this.nameTarget.value.trim() !== ""
    const addressFilled = this.addressTarget.value.trim() !== ""
    const alwaysOpenChecked = this.alwaysOpenTarget.checked

    // Prüfen, ob *alle* Öffnungszeiten-Felder (Mo-So) etwas enthalten
    const allOpeningTimesFilled = this.openingTimeTargets.every(field => field.value.trim() !== "")

    // Bedingung: Name & Adresse und (immer geöffnet ODER alle Wochentag-Felder ausgefüllt)
    if (nameFilled && addressFilled && (alwaysOpenChecked || allOpeningTimesFilled)) {
      // Alle Bedingungen erfüllt -> Button aktivieren
      this.submitTarget.removeAttribute("disabled")
    } else {
      // Mindestens ein Pflichtfeld fehlt -> Button deaktivieren
      this.submitTarget.setAttribute("disabled", "disabled")
    }
  }
}
