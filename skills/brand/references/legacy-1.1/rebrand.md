# Rebrand

Read by `SKILL.md` for a rebrand mission: the client asks for one, or a
review shows the positioning or the ambition has changed
(`references/revision.md`). "It looks old" is not enough: say so, and
offer a review instead.

A rebrand runs the meetings of a new mission (`SKILL.md`, `## The
meetings`), with the same ritual (minutes, appointment, the team at work,
`/clear` or `/exit`). What changes is below, meeting by meeting. The
mission's first `SESSIONS.md` entry carries the machine line
`- mission: rebrand` (`SESSIONS.md` is append-only, so a brand that
already had a mission keeps its old entries above it: the **last**
`- mission:` line is the one that counts). On resume, the session start
says it is a rebrand and brings you back here.

## 0. First contact

- **"Why now?" first.** What changed (the audience, the ambition, the
  product, a name grown too narrow), in the client's words. It is the
  diagnosis the whole mission answers.
- **Archive the current brand** first, before writing anything for the
  rebrand (the proposal included), so that the archive holds the brand as
  it was: copy what exists (`FOUNDATIONS.md`, `STRATEGY.md`,
  `VOICE.md`, `DECISIONS.md`, `BRIEF.md`, `SESSIONS.md`, `documents/`,
  `presentations/`; a brand from BRACE 1.0 may have only the first four)
  into `docs/brace/brand/archive/<YYYY-MM-DD>/`. Nothing is ever removed
  from the archive.
- **The proposal** (`references/contact.md`, adapted): the scope adds the
  audit, the choice of the extent, the transition plan and the
  announcement; the meetings are the same five; the budget is higher than
  a new mission's when documents are missing.
- Once it is accepted, write the mission's first `SESSIONS.md` entry with `- mission: rebrand`, set
  `brand_stage: brief`, then the workshop or an appointment.

## 1. Framing workshop

`references/workshop.md`, with the brief pre-filled **from the current
brand** (its files, its front page, its documents). The questions focus on
what a rebrand needs:

1. **What no longer works**: list it with the client, point by point (the
   problem sprint). Offer what you spotted.
2. **What must stay at all costs**: what people already recognise. Offer
   your guess (the name, a phrase, a tone).
3. **What changed**: the audience, the ambition, the product.
4. **The languages**, as always.

Then the team works (`references/backstage.md`, after the workshop), plus:
the analyst researches the existing brand (perception, where it appears);
the strategist writes the `audit`, and gives each route its before and
after.

## 2. Strategic recommendation

`references/presentation.md`, in this order:

1. **The audit**, a `doc` slide that sums up the `audit` document (what
   exists and holds, what is dated, what is missing; the equity to keep;
   what no longer works) and points to it.
2. **The extent, as a decision**, a `reco` slide: a refresh (keep the
   core, modernise), a repositioning, or a new name, one `item` each, the
   agency's recommendation and why; the client decides.
3. **The routes**, each with a `compare` slide: today next to tomorrow
   (promise, audience, tagline, tone, name).

The minutes record the extent chosen. A new name: the analyst checks its
availability in the next backstage (a check, never legal advice), and
`references/name.md` applies.

## 3. Brand platform

`references/adjustments.md`. The team writes, between meetings 2 and 3:
the documents the audit found dated (as the extent decided), **and every
brand document that was never made** (a brand from 1.0 has no brief,
minutes, benchmark, personas, routes, platform, editorial guide or
manifesto as documents). A document that still holds is kept, never
redone. They are presented together at the platform meeting, where the
feedback is taken at once (`references/adjustments.md`).

## 4. Delivery

`references/delivery.md`, with:

1. **The test** asks one more question of the people who already know the
   brand: "Do you still recognise it? What would you miss?"
2. **The chosen route's `compare` slide** again, then **the transition
   plan** (`transition`) and **the announcement** (`announcement`), shown
   and validated.
3. **Apply the transition**, in this order:
   - **What the agency does itself**, under `## Saving`: the tagline and
     one-liner on the project's front page; `project:` in `STATUS.md` (the
     portfolio follows); the occurrences of the old name in the repo that
     the plan lists, shown first and validated at once; the "formerly
     <old name>" mention where the plan puts it.
   - **What needs a separate confirmation**, because it is public:
     renaming the GitHub repository (`gh repo rename <new>`) and pointing
     the remote at it (`git remote set-url origin <new url>`).
   - **What the client does**: whatever the plan lists outside the repo
     (packages, profiles, domain).
4. Close the mission as usual (`references/delivery.md`): in
   `docs/brace/brand/DECISIONS.md`, what is kept and what is dropped from
   the heritage, with a link to the archive.

## The folder, last

Whenever the brand's name differs from the project's folder name, after a
rebrand or a repositioning alike (the name need not have changed during
the mission: a folder still carrying an old name counts), recommend the
rename. The rule is in the strategist's brief for the transition plan
(`references/backstage.md`), so the plan recommends it too. Ask in one
question, in her words (for example: your project is now called <name>;
shall I rename its folder?), with the rename as the recommended choice.
The client decides.
It is the session's **very last action**: everything above done and saved,
the mission closed. After it, nothing runs in this session (every command
and write would point at a folder that no longer exists).

**Do it yourself** unless the BRACE plugin runs from this very folder (a
`--plugin-dir` pointing inside it, as when BRACE works on itself): then
use the fallback below, since the plugin's own hooks would vanish with the
folder. Tell the client a hook message may show right after the rename
and is harmless.

Fill in the two paths between the single quotes (use double quotes only if
a path contains a single quote), then run, in one command:

```bash
OLD='<old absolute path>'; NEW='<new absolute path>'
key() { printf '%s' "$1" | sed 's/[^A-Za-z0-9]/-/g'; }
OLD_MEM="$HOME/.claude/projects/$(key "$OLD")"; NEW_MEM="$HOME/.claude/projects/$(key "$NEW")"
if [ -e "$NEW" ]; then echo "$NEW already exists: nothing renamed"
elif mv "$OLD" "$NEW"; then echo "folder renamed"
  if [ ! -d "$OLD_MEM" ]; then echo "no memory folder for the old path"
  elif [ -e "$NEW_MEM" ]; then echo "memory not copied: $NEW_MEM already exists"
  else cp -R "$OLD_MEM" "$NEW_MEM" && echo "memory copied (the old one stays as a backup)"; fi
else echo "folder not renamed: nothing moved"; fi
```

Claude Code keeps a project's memory and history under
`~/.claude/projects/<path key>/`. The memory is copied, not moved: this session still writes its last lines
there, and the old copy stays as a backup. Report exactly what the command
printed. Renamed: "It is done. Type `/exit` and reopen your project in
<new path>." Write nothing more.

Fallback (the plugin runs from this folder, the client prefers to do it,
or the command failed): give the same command, filled in, to run after
`/exit` from the parent folder.

On Antigravity, rename the folder only (its memory is not kept by path).
