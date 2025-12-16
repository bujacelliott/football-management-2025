# Football Management 25

A modernised remake of the classic Ultimate Football Management series, updated for the 2025 season.

## What's New

- **Current squads** - Real 2024/25 players and teams
- **Relegation & promotion** - Fight to stay up or earn your place in the top flight
- **Youth academy** - Develop the next generation of talent
- **Rebalanced morale** - Players won't throw tantrums every other week
- **Expanded leagues** - More divisions, more teams, more paths to glory
- **Fresh UI** - Cleaner, more intuitive interface

## Getting Started

### Prerequisites

- **Adobe AIR SDK** or **Apache Flex SDK** - Contains the ActionScript compiler and framework libraries
  - [Download Apache Flex SDK](https://flex.apache.org/installer.html) (free, open-source)
  - [Download Adobe AIR SDK](https://airsdk.harman.com/) (HARMAN maintains AIR)
- **VSCode** with the [AS3 & MXML extension](https://marketplace.visualstudio.com/items?itemName=bowlerhatllc.vscode-as3mxml) (optional, for development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/bujacelliott/football-management-2025.git
   cd football-management-2025
   ```

2. Update the SDK path in `.vscode/settings.json` to point to your Flex/AIR SDK installation.

3. Build the project:
   ```bash
   mxmlc -load-config+=asconfig.json
   ```
   This outputs `bin/UFM.swf`.

4. Run the application:
   ```bash
   adl src/UFM-app.xml bin/
   ```
   Or launch directly from VSCode using the debug configuration.

## Attribute conversion (FIFA → game)

Converted player data (e.g. `data/Liverpool_converted.csv`) is produced by `tools/attribute_converter_bucket.py`:
- **Stat weights:** Each game stat is a weighted average of FIFA attributes (see script).
- **Buckets → stars:** FIFA overall is mapped to a target in-game rating via buckets (90–94 → 80–84.5, 85–89 → 76–79.5, 80–84 → 71–74.5, 75–79 → 66–69.5, 70–74 → 61–64.5, 65–69 → 56–59.5, 60–64 → 51–54.5, 55–59 → 46–49.5, ≤54 → 40–44.5). Stars are computed with the game formula on the scaled rating.
- **Multi-position scaling:** Ratings are averaged across all listed positions (with the game’s multi-pos bonus), then all stats are scaled proportionally to hit the bucket target.
- **Age improvement:** Generated XML sets `ageImprovement="0"` so players load at the provided stats (no hidden drop).
- **CSV fields:** `name, pos, positions_full, fifa_overall, game_rating, stars, stat_*` (scaled stats).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

*TBD*
