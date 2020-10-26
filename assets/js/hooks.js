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

export default Hooks;