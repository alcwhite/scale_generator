import {LitElement, html, css} from 'lit'

export class ScaleNote extends LitElement {
  static get styles() {
    return [
      css`
      .glow {
        text-shadow: 0px 0px 3px white,
                    0px 0px 5px white, 
                    0px 0px 6px orangered,
                    0px 0px 7px orangered,
                    0px 0px 8px orangered,
                    0px 0px 10px orangered;
        color: white;
      }
      .note {
        margin: 3px;
      }
    `
    ];
  }

  static properties = {
    index: { type: Number },
    playing: { type: Boolean },
    note: { type: String },
    direction: { type: String }
  }

  get classes() { return this.playing ? "note glow" : "note" }

  constructor() {
    super()
    this.addEventListener("playing-note", this._playingNote)
    this.addEventListener("stopping-player", () => this.playing = false)
  }

  _playingNote(event) {
    const {detail: {direction, index}} = event
    this.playing = index === event.target.index && direction === event.target.direction ? true : false
  }
 
  render() {
    return html`<span class="${this.classes}">${this.note}</span>`
  }
}

customElements.define("scale-note", ScaleNote)
