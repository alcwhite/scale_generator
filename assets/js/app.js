// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let Hooks = {}

Hooks.PlayScale = {
    timeouts: [],
    scale: "",
    action: "",
    allNotes: [],
    mounted() {
        this.scale = this.el.getAttribute("data-recording");
        this.action = this.el.getAttribute("data-action");
        this.el.addEventListener("click", () => this.playScale());
    },
    updated() {
        this.scale = this.el.getAttribute("data-recording");
        if (this.action == "Stop") {
            this.playScale()
        }
        this.action = this.el.getAttribute("data-action");
        this.el.addEventListener("click", () => this.playScale());
    },
    playScale() {
        if (this.action === "Play") {
            this.action = "None";
            this.allNotes = Array.from(this.el.parentElement.getElementsByClassName("note"));
            this.pushEvent("play", {});
            let notes = this.scale.split(" ").map(note => new Audio(`/sounds/${note}.mp3`));
            this.timeouts = notes.map((note, i) => setTimeout(() => {
                this.allNotes.forEach(note => {
                    note.className = "note"; 
                 });
                 this.allNotes[i].className = "note glow";
                note.play();
            }, 750 * i + 1200));
            this.timeouts.push(setTimeout(() => {
                    this.allNotes.forEach(note => {
                       note.className = "note"; 
                    });
                    this.pushEvent("stop", {});
                }, notes.length * 750 + 1200));
        }
        if (this.action === "Stop") {
            this.action = "None";
            this.timeouts.map(t => clearTimeout(t));
            this.allNotes.forEach(note => {
                note.className = "note"; 
             });
            this.pushEvent("stop", {});
        }
    }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})
liveSocket.connect()
