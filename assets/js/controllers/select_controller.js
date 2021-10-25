import { application } from "../app"
import { Controller } from "@hotwired/stimulus"

application.register("select", class extends Controller {
  change(_event) {
    this.dispatch("select-scale", )
  }
})

