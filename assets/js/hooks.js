let Hooks = {}

Hooks.PlayScale = {
    timeouts: [],
    scale: "",
    action: "Play",
    allNotes: [],
    updated() {
        this.action = this.el.getAttribute("data-action");
        this.el.innerText = this.action;
        this.scale = this.el.getAttribute("data-recording");
        if (this.action == "Stop") {
            this.playScale();
        } else {
            this.stopPlayer();
        }
    },
    stopPlayer() {
        this.timeouts.map(t => clearTimeout(t));
        this.allNotes.forEach(note => {
            note.className = "note"; 
        });
    },
    playScale() {
        if (this.action === "Stop") {
            this.allNotes = Array.from(this.el.parentElement.getElementsByClassName("note"));
            let notes = this.scale.split(" ").map(note => new Audio(`/sounds/${note}.mp3`));
            this.timeouts = notes.map((note, i) => setTimeout(() => {
                if (i > 0) { this.allNotes[i - 1].classList.remove("glow"); }
                this.allNotes[i].classList.add("glow");
                note.play();
            }, 750 * i + 100));
            this.timeouts.push(setTimeout(() => {
                this.stopPlayer();
                this.pushEvent("clickplayer", {});
            }, notes.length * 750 + 100));
        }
    }
}

export default Hooks;