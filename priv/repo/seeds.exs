# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ScaleGenerator.Repo.insert!(%ScaleGenerator.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ScaleGenerator.Repo
alias ScaleGenerator.Scales.Scale

Repo.insert!(%Scale{name: "major", asc_pattern: "MMmMMMm", desc_pattern: "mMMMmMM"})
Repo.insert!(%Scale{name: "minor", asc_pattern: "MmMMmMM", desc_pattern: "MMmMMmM"})
Repo.insert!(%Scale{name: "chromatic", asc_pattern: "mmmmmmmmmmmm", desc_pattern: "mmmmmmmmmmmm"})
Repo.insert!(%Scale{name: "dorian", asc_pattern: "MmMMMmM", desc_pattern: "MmMMMmM"})
Repo.insert!(%Scale{name: "mixolydian", asc_pattern: "MMmMMmM", desc_pattern: "MmMMmMM"})
Repo.insert!(%Scale{name: "lydian", asc_pattern: "MMMmMMm", desc_pattern: "mMMmMMM"})
Repo.insert!(%Scale{name: "phrygian", asc_pattern: "mMMMmMM", desc_pattern: "MMmMMMm"})
Repo.insert!(%Scale{name: "locrian", asc_pattern: "mMMmMMM", desc_pattern: "MMMmMMm"})
Repo.insert!(%Scale{name: "harmonic minor", asc_pattern: "MmMMmAm", desc_pattern: "mAmMMmM"})
Repo.insert!(%Scale{name: "melodic minor", asc_pattern: "MmMMMMm", desc_pattern: "MMmMMmM"})
Repo.insert!(%Scale{name: "octatonic", asc_pattern: "MmMmMmMm", desc_pattern: "mMmMmMmM"})
Repo.insert!(%Scale{name: "hexatonic", asc_pattern: "MMMMMM", desc_pattern: "MMMMMM"})
Repo.insert!(%Scale{name: "pentatonic", asc_pattern: "MMAMA", desc_pattern: "AMAMM"})
Repo.insert!(%Scale{name: "enigmatic", asc_pattern: "mAMMMmm", desc_pattern: "mmMMMAm"})
Repo.insert!(%Scale{name: "minor pentatonic", asc_pattern: "AMMAM", desc_pattern: "MAMMA"})
Repo.insert!(%Scale{name: "blues", asc_pattern: "MMMmMA", desc_pattern: "MMMmMA"})
Repo.insert!(%Scale{name: "minor blues", asc_pattern: "AMmmAM", desc_pattern: "MAmmMA"})
