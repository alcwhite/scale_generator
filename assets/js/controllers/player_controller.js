import { application } from "../app"
import { Controller } from "@hotwired/stimulus"

application.register("player", class extends Controller {
  static targets = ["button", "note"]
  static classes = ["playing"]

  get playText() { return "Play" }
  get stopText() { return "Stop" }

  connect() {
    this.playing = false
    this.timeouts = []
  }

  stop_or_start(event) {
    this.playing ? this.stop(event) : this.play(event)
  }

  play(event) {
    this.playing = true
    this.buttonTarget.innerHTML = this.stopText
    const notes = event.params.recording.split(" ").map(note => new Audio(`/sounds/${note}.mp3`));
    this.timeouts = notes.map((note, i) => setTimeout(() => {
      this.noteTargets[i - 1]?.classList?.remove(this.playingClass)
      this.noteTargets[i].classList.add(this.playingClass)
      note.play()
    }, 750 * i));
    this.timeouts.push(setTimeout(() => {
      this.stop(event)
    }, notes.length * 750))
  }

  stop(_event) {
    this.playing = false
    this.buttonTarget.innerHTML = this.playText
    this.timeouts.map(t => clearTimeout(t))
    this.noteTargets.forEach(note => {
      note.classList.remove(this.playingClass)     
    })
  }
})

