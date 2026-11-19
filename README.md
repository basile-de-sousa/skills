# skills

My skills for Claude, versioned.

> **This repo is a mirror.** The source of truth for each skill is its version on claude.ai.
> Here: one snapshot per release, its history, and the zip to install.

Most skills are written in French and reply in the language you write in. `spec` is written in English.

## Published skills

| Skill | What it does |
|---|---|
| [spec](skills/spec/SKILL.md) | Spec-driven workflow for a git repo: specs, ADRs, current-truth docs, execution |
| [trad](skills/trad/SKILL.md) | English practice for French speakers: FR↔EN translation with rephrasings |
| [pin](skills/pin/SKILL.md) | Pin a tool, site, technology, idea or read with a "useful when", in your own GitHub repo |
| [buzzword](skills/buzzword/SKILL.md) | Ultra-short card to understand and explain out loud an IT strategy or enterprise architecture term |
| [note](skills/note/SKILL.md) | Compile raw notes into one clean HTML page per topic |
| [sonar](skills/sonar/SKILL.md) | Find what you already saved (pins, buzzwords, notes, methods) when you start on a topic, and why it matters or not |
| [skills-release](skills/skills-release/SKILL.md) | Publish a skill release to a sharing repo like this one (start from a copy of this repo) |

## Install a skill

1. Open [Releases](../../releases) and download the zip of the skill you want.
2. Add it to your skills in claude.ai.
3. If the skill has a Config block set to `<à définir>` ("to be defined"), it will ask for your values (for example your data repo) on first run.

With Claude Code, copying the `skills/<name>/` folder into `~/.claude/skills/` is enough.

## History

- `git log --oneline --grep "release: <skill>"`: the versions of a skill, with their release note.
- [docs/architecture.md](docs/architecture.md): how this repo works (in French).
