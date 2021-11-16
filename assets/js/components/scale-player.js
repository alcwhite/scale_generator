import {LitElement, html, css} from 'lit'

export class ScalePlayer extends LitElement {
  static get styles() {
    return [
      css`
      button {
        background-color: #0069d9;
        border: 0.1rem solid #0069d9;
        border-radius: 0.4rem;
        color: #fff;
        cursor: pointer;
        display: inline-block;
        font-size: 1.1rem;
        font-weight: 700;
        height: 3.8rem;
        letter-spacing: .1rem;
        line-height: 3.8rem;
        padding: 0 3rem;
        text-align: center;
        text-decoration: none;
        text-transform: uppercase;
        white-space: nowrap;
      }
      `
    ];
  }

  static properties = {
    recording: { type: String },
    playing: { type: Boolean }
  }

  get playingText() { return "Stop" }
  get stoppedText() { return "Play" }
  get notes() { return this.recording.split(" ") }
  get text() { return this.playing ? this.playingText : this.stoppedText }

  constructor() {
    super()
    this.addEventListener("change-scale", this._stop)
    this.timeouts = []
  }

  _playOrStop(_event) {
    this.playing ? this._stop() : this._play()
  }

  _play() {
    this.playing = true
    this.timeouts = this.notes.map((note, i) => setTimeout(() => {
      Array.from(document.querySelectorAll("scale-note")).forEach((item, index) => {
        const el = item.renderRoot.querySelector(".note")
        i === index ? el.classList.add("glow") : el.classList.remove("glow")
      })
      new Audio(`/sounds/${note}.mp3`).play()
    }, 750 * i))
    this.stopTimeout = setTimeout(() => {
      this._stop()
    }, 750 * this.notes.length)
  }

  _stop() {
    this.timeouts.map(t => clearTimeout(t))
    Array.from(document.querySelectorAll("scale-note"))
      .forEach(item => item.renderRoot.querySelector(".note").classList.remove("glow"))
    clearTimeout(this.stopTimeout)
    this.playing = false
  }

  render() {
    return html`<button id="playerButton" @click=${this._playOrStop}>${this.text}</button>`
  }
}

customElements.define("scale-player", ScalePlayer)
