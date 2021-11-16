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
        cursor: pointer;
      }
    `
    ];
  }

  static properties = {
    playing: { type: Boolean },
    note: { type: String },
    recording: {type: String},
  }

  get classes() { return this.playing ? "note glow" : "note" }

  _playNote() {
    this.playing = true
    new Audio(`/sounds/${this.recording}.mp3`).play()
    setTimeout(() => {
      this.playing = false
    }, 750)
  }
 
  render() {
    return html`<span @click="${this._playNote}" class="${this.classes}">${this.note}</span>`
  }
}

customElements.define("scale-note", ScaleNote)
