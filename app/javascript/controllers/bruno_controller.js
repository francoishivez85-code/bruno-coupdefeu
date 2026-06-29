import { Controller } from "@hotwired/stimulus"

// Ouvre/ferme la fenetre de chat Bruno en basculant la classe "is-open"
// sur l'élément .bruno-chat.
// Le micro sera ajouté ici plus tard (branche feature/bruno-micro).
export default class extends Controller {
  open() {
    this.element.classList.add("is-open")
  }

  close() {
    this.element.classList.remove("is-open")
  }
}
