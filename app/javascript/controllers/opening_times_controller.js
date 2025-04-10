import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sameEveryDayCheckbox", "masterInput", "dayInput"]

  connect() {
    this.toggleFields()

    this.element.closest("form")?.addEventListener("submit", () => {
      if (this.sameEveryDayCheckboxTarget.checked) {
        this.applyToAll()
      }
    })
  }

  toggleFields() {
    const same = this.sameEveryDayCheckboxTarget.checked

    // Zentrales Feld sichtbar machen oder verstecken
    this.masterInputTarget.closest(".form-group").style.display = same ? "block" : "none"

    // Statt .disabled → nur optisch deaktivieren
    this.dayInputTargets.forEach(input => {
      input.readOnly = same
      input.classList.toggle("visually-disabled", same)
    })

    // Wenn Checkbox angeklickt wurde und Wert vorhanden → sofort anwenden
    if (same && this.masterInputTarget.value.trim() !== "") {
      this.applyToAll()
    }
  }

  applyToAll() {
    const raw = this.masterInputTarget.value.trim()
    const formatted = this.formatTimeRange(raw)

    this.dayInputTargets.forEach(input => {
      input.value = formatted

      // 🔥 simuliert echtes Tippen → triggert form-validation automatisch
      input.dispatchEvent(new Event("input", { bubbles: true }))
    })
  }

  formatTimeRange(text) {
    return text
      .replace("bis", "-")
      .replace("–", "-")
      .replace(/ /g, "")
      .replace(/^(\d{1,2})-(\d{1,2})$/, (_, start, end) => {
        return `${this.pad(start)}:00–${this.pad(end)}:00`
      })
      .replace(/^(\d{1,2}):?(\d{2})?-(\d{1,2}):?(\d{2})?$/, (_, sh, sm, eh, em) => {
        const start = `${this.pad(sh)}:${this.pad(sm || "00")}`
        const end = `${this.pad(eh)}:${this.pad(em || "00")}`
        return `${start}–${end}`
      })
  }

  pad(num) {
    return num.toString().padStart(2, "0")
  }
}
