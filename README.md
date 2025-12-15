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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

*TBD*
