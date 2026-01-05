# Multiple playable leagues (how it works + how to add it)

This project is written in ActionScript 3. At a high level, “multiple playable leagues” is implemented by:

1. Building **all leagues up-front** into `Main.currentGame.leagues` (an `Array` of `League` objects).
2. Showing a **league selector UI** that lets the player choose which league’s clubs are available to pick from.
3. Storing the selection as an **index** (`Main.currentGame.mainLeagueNum`) so the rest of the game can always ask “what is the current (player’s) league?”.

The core design is “one `Game` object, many leagues loaded; your selected league is just a pointer”.

---

## 1) The data model (where leagues live)

### `Game.leagues` is the master list

`src/com/utterlySuperb/chumpManager/model/dataObjects/Game.as` defines:

- `public var leagues:Array;`  
  Holds all loaded `League` instances (and the “Euro clubs” league used for cups).
- `public var mainLeagueNum:int;`  
  The array index that represents the *selected main league*.
- `public function getMainLeague():League` and `getSecondDivision():League`  
  Convenience methods that return the current selected league(s) based on `mainLeagueNum`.

This codebase uses a **paired-index convention**:

- The top division index is **even**.
- The second division index is the next **odd** index.

Examples (from `Game.as` constants):

- `LEAGUE_ENG_1 = 0`, `LEAGUE_ENG_2 = 1`
- `LEAGUE_SPA_1 = 2`, `LEAGUE_SPA_2 = 3`
- …

That’s why `getSecondDivision()` is implemented as `mainLeagueNum + 1`.

### `League` is just a competition with entrants

`src/com/utterlySuperb/chumpManager/model/dataObjects/competitions/League.as` extends `Competition` and stores:

- `entrants:Array` (each entrant is a `CompetitionInfo` that wraps a `Club`)
- standings logic (`getStandings()` sorts by points/goal difference/goals scored)

Most league-specific behavior (fixtures, cups, transfers, etc.) is done elsewhere by looking at the currently selected league via `Game.getMainLeague()`.

---

## 2) Where the league data comes from

### Leagues are constructed in `GameEngine.makeGame()`

This codebase hardcodes league data as `XML` literals inside:

- `src/com/utterlySuperb/chumpManager/engine/GameEngine.as` → `makeGame()`

The pattern repeated throughout the file is:

1. Assign a block of `<club ...>...</club>` data to an `XML` variable.
2. Convert that XML into a `League` via `makeLeague(xml, "leagueNameId")`.
3. Store it into `game.leagues[Game.LEAGUE_...]`.

`makeLeague(xml, nameId)` is the key helper:

- Creates a new `League`
- Sets `league.name = nameId` (used for localization via `CopyManager.getCopy`)
- Loops `<club>` nodes and converts each into a `Club` via `TeamHelper.makeClub()`
- Adds each club as an entrant (`League.addEntrant`)

If your 2010 version only has one league playable, it typically means **only one `League` is being built/added**, or the UI only offers one league to choose from (or both).

---

## 3) What makes a league “playable”

### The selector UI decides “playable”

In this project, “playable leagues” are the leagues that appear on the team selection screen:

- `src/com/utterlySuperb/chumpManager/view/panels/SelectTeamPanel.as`

`SelectTeamPanel.init()` is currently hardcoded to add several top divisions:

- `Main.currentGame.leagues[Game.LEAGUE_ENG_1]`
- `Main.currentGame.leagues[Game.LEAGUE_SPA_1]`
- `Main.currentGame.leagues[Game.LEAGUE_ITA_1]`
- …

When the player clicks a team, `selectTeamHandler()` does the critical wiring:

- `Main.currentGame.setPlayerclub(selectedClub)`
- `Main.currentGame.mainLeagueNum = Main.currentGame.leagues.indexOf(this.league)`
- Calls `GameEngine.initSeason()` (or a challenge init)

From that point onward, *everything* that cares about “your league” uses:

- `Main.currentGame.getMainLeague()`
- `Main.currentGame.getSecondDivision()`

So “making more leagues playable” is mostly:

1. Ensure the leagues exist in `game.leagues`.
2. Ensure the selector lists them.
3. Ensure the code that assumes “only one league” is updated to use `mainLeagueNum` / `getMainLeague()`.

---

## 4) Adding another playable league in THIS codebase (UFM2015)

### Step A — add the league constants (indexing)

Add new constants in:

- `src/com/utterlySuperb/chumpManager/model/dataObjects/Game.as`

Keep the even/odd pair convention. Example:

```as3
public static const LEAGUE_USA_1:int = 18;
public static const LEAGUE_USA_2:int = 19;
```

If you also add another “special” league (like `LEAGUE_EUROCLUBS`), give it its own unique index.

### Step B — build the new leagues in `GameEngine.makeGame()`

In:

- `src/com/utterlySuperb/chumpManager/engine/GameEngine.as`

Add another XML block for the new league’s clubs and then:

- `game.leagues[Game.LEAGUE_USA_1] = makeLeague(xmlTopDivision, "mls");`
- `game.leagues[Game.LEAGUE_USA_2] = makeLeague(xmlSecondDivision, "usl");`

Notes:

- The `nameId` string must exist in your copy/localization files or the UI will show missing text.
- `TeamHelper.makeClub()` expects the `<club>` XML to include the fields your game needs (shirt colors, profile, players, etc.).

### Step C — expose it in the selector

In:

- `src/com/utterlySuperb/chumpManager/view/panels/SelectTeamPanel.as`

Add another league button by calling `addLeagueButton(Main.currentGame.leagues[Game.LEAGUE_USA_1])`.

That’s the “playable” switch in this project.

### Step D — audit hardcoded “8 leagues” logic

Some logic assumes a fixed set of leagues (because earlier versions of the game shipped with a fixed set). The big ones to review:

- `src/com/utterlySuperb/chumpManager/engine/GameHelper.as`
  - `getNonPlayedMainLeague()` uses a modulo-based calculation tied to 8 leagues.
- `src/com/utterlySuperb/chumpManager/model/dataObjects/competitions/Competition.as`
  - `getName()` has special-case translations for only a few leagues based on `mainLeagueNum`.
- `src/com/utterlySuperb/chumpManager/engine/PlayerHelper.as`
  - Player nationality generation uses `mainLeagueNum / 2` as a “country id”.

If you add more playable leagues, update these pieces so they use:

- a list of playable main league indices (e.g. `[LEAGUE_ENG_1, LEAGUE_SPA_1, ...]`)
- or a “country code” stored on the league itself (recommended long-term)

Otherwise the game may still run, but things like cup selection/nationalities/copy selection can become incorrect.

---

## 5) Integrating the idea into your 2010 version (general porting guide)

Because I don’t have your 2010 source in this repo, the steps below describe the *minimal architecture changes* you typically need to port.

### Step 1 — locate (or add) the “league store”

Find where your 2010 game stores league data today. Often it’s one of these:

- a single `League` variable (e.g. `game.league`)
- a single array of clubs used for the season
- an embedded XML/JSON file that only contains one league

Convert that to:

- `game.leagues:Array` holding multiple `League` objects
- `game.mainLeagueNum:int` identifying which one is currently selected

If you can’t change the structure everywhere at once, add these fields and keep the old one temporarily, but plan to migrate all gameplay code to `getMainLeague()` style access.

### Step 2 — always refer to “current league” through a getter

Add methods like:

- `getMainLeague():League`
- `getSecondDivision():League` (optional)

Then update code that previously referenced the single league directly so it calls `getMainLeague()` instead.

This is the single most important refactor because it keeps the rest of your code league-agnostic.

### Step 3 — build/load multiple leagues before team selection

In your “new game” or “makeGame” equivalent:

- load/build every league you want available
- push them into `game.leagues` in a stable order

Stable ordering matters because saves and `mainLeagueNum` depend on indices.

### Step 4 — add a league selection UI

You need a screen/panel that:

1. Displays the available leagues (buttons, dropdown, flags, etc.)
2. When a league is chosen, shows that league’s clubs for selection
3. When a club is chosen:
   - sets `playerClub`
   - sets `mainLeagueNum`
   - starts the season

You can copy the interaction pattern from this repo’s `SelectTeamPanel.as`.

### Step 5 — update saves (if your 2010 version supports saving)

If your 2010 version serializes the `Game` state, you must include:

- `mainLeagueNum`
- and the `leagues` array (or enough information to rebuild it deterministically)

In this repo, saving is handled by:

- `src/com/utterlySuperb/chumpManager/engine/SavesManager.as`
- `src/com/utterlySuperb/chumpManager/engine/GameSaveConverter.as`

If your 2010 save files don’t contain these fields, you’ll also need a simple “save upgrade” path:

- if `mainLeagueNum` is missing, default it to the original league’s index (usually `0`)

---

## 6) Quick checklist

- [ ] Multiple `League` objects exist in `game.leagues`
- [ ] UI lists more than one league
- [ ] On selection, you set `game.mainLeagueNum` (not just `playerClub`)
- [ ] All “current league” logic uses `getMainLeague()` (not a hardcoded league)
- [ ] Save/load preserves the league index (and any league data you need)

---

## If you want, I can tailor this to your 2010 build

If you can share (paste or add to this workspace) the 2010 source files that:

- create the game/new season, and
- show the team/league selection screen,

I can write a more exact, file-by-file integration plan (and even implement the changes) for that version.

