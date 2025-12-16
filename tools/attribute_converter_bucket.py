"""
FIFA-style attribute converter with bucket-based rescaling.

Flow:
- Build game stats from FIFA attributes (weighted averages).
- Compute base positional rating (matches PlayerHelper weights).
- Map FIFA overall to a target rating via buckets (aligned to star bands).
- Scale all stats proportionally so the positional rating hits the target.

Example:
    python tools/attribute_converter_bucket.py data/english_players.csv Arsenal out.csv
"""

import csv
import math
import sys
from pathlib import Path
from typing import Dict, List

# Buckets mapping FIFA overall to target in-game rating ranges
# (aligned to star bands: 10★>85, 9★(80,85], 8★(75,80], 7★(70,75], 6★(65,70], 5★(60,65], 4★(55,60], 3★(50,55], 2★(45,50], 1★<=45)
# Buckets mapping FIFA overall to target in-game rating ranges
# Tuned so upper ends stay just below the next star threshold
BUCKETS = [
    (95, 99, 85, 90, 10),       # 10★
    (90, 94, 80, 84.5, 9),      # 9★ (keeps comfortably <85)
    (85, 89, 76, 79.5, 8),      # 8★ (keeps comfortably <80)
    (80, 84, 71, 74.5, 7),      # 7★
    (75, 79, 66, 69.5, 6),      # 6★
    (70, 74, 61, 64.5, 5),      # 5★
    (65, 69, 56, 59.5, 4),      # 4★
    (60, 64, 51, 54.5, 3),      # 3★
    (55, 59, 46, 49.5, 2),      # 2★
    (0, 54, 40, 44.5, 1),       # 1★
]

# FIFA column weights -> game stats
STAT_WEIGHTS: Dict[str, Dict[str, float]] = {
    "passing": {
        "attacking_short_passing": 35,
        "skill_long_passing": 20,
        "mentality_vision": 15,
        "skill_ball_control": 10,
        "mentality_composure": 10,
        "movement_reactions": 10,
    },
    "tackling": {
        "defending_standing_tackle": 40,
        "defending_marking_awareness": 20,
        "mentality_interceptions": 15,
        "defending_sliding_tackle": 15,
        "movement_reactions": 5,
        "power_strength": 5,
    },
    "heading": {
        "attacking_heading_accuracy": 40,
        "power_jumping": 30,
        "power_strength": 20,
        "mentality_aggression": 10,
    },
    "shooting": {
        "attacking_finishing": 35,
        "power_shot_power": 20,
        "power_long_shots": 15,
        "mentality_positioning": 10,
        "mentality_composure": 10,
        "attacking_volleys": 5,
        "movement_reactions": 5,
    },
    "crossing": {
        "attacking_crossing": 50,
        "skill_curve": 15,
        "mentality_vision": 10,
        "attacking_short_passing": 10,
        "skill_long_passing": 10,
        "skill_ball_control": 5,
    },
    "dribbling": {
        "skill_dribbling": 30,
        "skill_ball_control": 25,
        "movement_agility": 15,
        "movement_balance": 10,
        "movement_reactions": 10,
        "mentality_composure": 10,
    },
    "speed": {"movement_acceleration": 50, "movement_sprint_speed": 50},
    "max_stamina": {"power_stamina": 80, "power_strength": 10, "movement_balance": 10},
    "aggression": {
        "mentality_aggression": 70,
        "power_strength": 15,
        "mentality_interceptions": 10,
        "movement_reactions": 5,
    },
    "strength": {
        "power_strength": 70,
        "movement_balance": 15,
        "power_jumping": 10,
        "mentality_aggression": 5,
    },
    "fitness": {
        "power_stamina": 35,
        "power_strength": 25,
        "movement_acceleration": 15,
        "movement_sprint_speed": 15,
        "movement_agility": 10,
    },
    "creativity": {
        "mentality_vision": 40,
        "attacking_short_passing": 15,
        "skill_long_passing": 15,
        "skill_curve": 10,
        "skill_dribbling": 10,
        "skill_ball_control": 10,
    },
}

# Positional weights (PlayerHelper.getSpecificPositionScore)
POS_WEIGHTS: Dict[str, Dict[str, float]] = {
    "cf": {
        "tackling": 0.5,
        "heading": 4,
        "strength": 2.5,
        "speed": 3,
        "passing": 2,
        "shooting": 5,
        "dribbling": 2.4,
        "aggression": 2,
        "crossing": 2,
        "max_stamina": 2,
        "fitness": 1,
        "creativity": 3,
    },
    "wf": {
        "tackling": 1,
        "heading": 1.7,
        "strength": 2,
        "speed": 2.4,
        "passing": 2.2,
        "shooting": 2.5,
        "dribbling": 2.5,
        "aggression": 2,
        "crossing": 3,
        "max_stamina": 2,
        "fitness": 1,
        "creativity": 3,
    },
    "am": {
        "tackling": 1.3,
        "heading": 1.8,
        "strength": 2,
        "speed": 2.1,
        "passing": 3,
        "shooting": 2.5,
        "dribbling": 2.5,
        "aggression": 2,
        "crossing": 1.3,
        "max_stamina": 2,
        "fitness": 1,
        "creativity": 4,
    },
    "cm": {
        "tackling": 2,
        "heading": 1,
        "strength": 2,
        "speed": 2,
        "passing": 4,
        "shooting": 2,
        "dribbling": 2.5,
        "aggression": 2,
        "crossing": 1.3,
        "max_stamina": 2.5,
        "fitness": 1,
        "creativity": 2.5,
    },
    "dm": {
        "tackling": 4,
        "heading": 1,
        "strength": 2.2,
        "speed": 2,
        "passing": 1.7,
        "shooting": 1.4,
        "dribbling": 1.4,
        "aggression": 2,
        "crossing": 1.3,
        "max_stamina": 2.5,
        "fitness": 1,
        "creativity": 1,
    },
    "sm": {
        "tackling": 1.4,
        "heading": 1,
        "strength": 2,
        "speed": 2.5,
        "passing": 2.6,
        "shooting": 2.2,
        "dribbling": 2.1,
        "aggression": 1.8,
        "crossing": 4,
        "max_stamina": 2.5,
        "fitness": 1,
        "creativity": 2.5,
    },
    "fb": {
        "tackling": 3,
        "heading": 1.5,
        "strength": 2,
        "speed": 2.5,
        "passing": 2,
        "shooting": 1,
        "dribbling": 1.5,
        "aggression": 2,
        "crossing": 2.5,
        "max_stamina": 2.5,
        "fitness": 1,
        "creativity": 1,
    },
    "cb": {
        "tackling": 4,
        "heading": 4,
        "strength": 2.5,
        "speed": 2.3,
        "passing": 1.4,
        "shooting": 0.5,
        "dribbling": 0.5,
        "aggression": 2.3,
        "crossing": 0.5,
        "max_stamina": 2,
        "fitness": 1,
    },
    "wb": {
        "tackling": 2.2,
        "heading": 1.4,
        "strength": 1.9,
        "speed": 2.6,
        "passing": 2.2,
        "shooting": 1.6,
        "dribbling": 1.8,
        "aggression": 1.7,
        "crossing": 2.5,
        "max_stamina": 2.5,
        "fitness": 1,
        "creativity": 1,
    },
    "gk": {
        "catching": 2.3,
        "shot_stopping": 3,
        "distribution": 2.2,
        "keeper_stamina": 1.5,
        "keeper_fitness": 1,
    },
}

POS_MAP = {
    "ST": "cf",
    "CF": "cf",
    "CAM": "am",
    "LW": "wf",
    "RW": "wf",
    "LM": "sm",
    "RM": "sm",
    "CM": "cm",
    "CDM": "dm",
    "LB": "fb",
    "RB": "fb",
    "CB": "cb",
    "GK": "gk",
}

# Average positional rating across all mapped positions (with multi-position bonus)
BASE_POS_LIST = ["cf","wf","am","cm","dm","sm","fb","cb","wb","gk"]

def all_positions(raw: str) -> list:
    seen = []
    for p in raw.split(","):
        m = POS_MAP.get(p.strip().upper())
        if m and m not in seen:
            seen.append(m)
    return seen or ["cm"]

def multi_pos_rating(stats: dict, positions: list) -> float:
    scores = [position_rating(stats, p) for p in positions]
    avg = sum(scores)/len(scores)
    return avg * (0.95 + len(positions)/20.0)


# Precompute sums to avoid recomputing per row
STAT_SUMS = {k: sum(w.values()) for k, w in STAT_WEIGHTS.items()}
POS_SUMS = {k: sum(w.values()) for k, w in POS_WEIGHTS.items()}


def clamp(val: float, lo: float = 1, hi: float = 99) -> float:
    return max(lo, min(hi, val))


def num(val: str) -> float:
    s = str(val)
    if "+" in s:
        s = s.split("+", 1)[0]
    try:
        return float(s)
    except ValueError:
        return 0.0


def target_rating(fifa_overall: float) -> (float, float):
    for lo, hi, rlo, rhi, _stars in BUCKETS:
        if lo <= fifa_overall <= hi:
            span = hi - lo if hi != lo else 1
            pos = (fifa_overall - lo) / span
            return rlo + pos * (rhi - rlo), rhi
    return 40.0, 45.0


def star_from_rating(rating: float) -> int:
    return int(math.ceil(min(max(1, rating - 40), 60) / 50 * 10))


def weighted_stat(row: Dict[str, str], weights: Dict[str, float], total_w: float) -> float:
    return sum(num(row.get(col, 0)) * w for col, w in weights.items()) / total_w if total_w else 0.0


def build_outfield_stats(row: Dict[str, str]) -> Dict[str, float]:
    return {k: weighted_stat(row, w, STAT_SUMS[k]) for k, w in STAT_WEIGHTS.items()}


def build_keeper_stats(row: Dict[str, str]) -> Dict[str, float]:
    return {
        "catching": num(row.get("goalkeeping_handling", 0)),
        "shot_stopping": (num(row.get("goalkeeping_diving", 0)) + num(row.get("goalkeeping_reflexes", 0))) / 2,
        "distribution": num(row.get("goalkeeping_kicking", 0)),
        "keeper_stamina": num(row.get("power_stamina", 0)),
        "keeper_fitness": num(row.get("goalkeeping_positioning", 0)),
    }


def position_rating(stats: Dict[str, float], pos: str) -> float:
    weights = POS_WEIGHTS[pos]
    total_w = POS_SUMS[pos]
    return sum(stats.get(k, 0) * w for k, w in weights.items()) / total_w if total_w else 0.0


def scale_stats(stats: Dict[str, float], factor: float) -> Dict[str, int]:
    return {k: int(round(clamp(v * factor))) for k, v in stats.items()}


def map_position(raw: str) -> str:
    return POS_MAP.get(raw.split(",")[0].strip().upper(), "")


def map_positions_full(raw: str) -> str:
    seen = []
    for p in raw.split(","):
        m = POS_MAP.get(p.strip().upper())
        if m and m not in seen:
            seen.append(m)
    return "-".join(seen or ["cm"])


def fix_name(short_name: str, long_name: str) -> str:
    toks = short_name.split()
    if toks and toks[0].endswith("."):
        toks[0] = long_name.split()[0]
        return " ".join(toks)
    return short_name


def nat_code(nationality: str) -> str:
    return nationality[:2].lower()


def fmt_date(date_str: str) -> str:
    parts = date_str.split("-")
    if len(parts) == 3:
        y, m, d = parts
        return f"{d.zfill(2)}-{m.zfill(2)}-{y}"
    return date_str


def convert_row(row: Dict[str, str]) -> Dict[str, str]:
    pos_list = all_positions(row["player_positions"])
    pos = pos_list[0]
    if not pos:
        return {}
    is_gk = pos == "gk"
    stats = build_keeper_stats(row) if is_gk else build_outfield_stats(row)
    base = multi_pos_rating(stats, pos_list)
    target, target_max = target_rating(num(row["overall"]))
    factor = target / base if base else 1
    scaled_float = {k: v * factor for k, v in stats.items()}
    scaled_rating = multi_pos_rating(scaled_float, pos_list)
    if scaled_rating > target_max:
        adjust = target_max / scaled_rating if scaled_rating else 1
        scaled_float = {k: v * adjust for k, v in scaled_float.items()}
        scaled_rating = multi_pos_rating(scaled_float, pos_list)
    scaled = {k: int(round(clamp(v))) for k, v in scaled_float.items()}
    scaled_rating = multi_pos_rating(scaled, pos_list)
    return {
        "name": fix_name(row["short_name"], row["long_name"]),
        "pos": pos,
        "positions_full": map_positions_full(row["player_positions"]),
        "fifa_overall": row["overall"],
        "game_rating": round(scaled_rating, 2),
        "stars": star_from_rating(scaled_rating),
        "nat": nat_code(row["nationality_name"]),
        "dob": fmt_date(row["dob"]),
        "number": row["club_jersey_number"] or "0",
        "scaled_stats": scaled,
    }


def run(csv_path: Path, club: str) -> List[Dict[str, str]]:
    rows_out: List[Dict[str, str]] = []
    with csv_path.open() as f:
        reader = csv.DictReader(f)
        for row in reader:
            if row.get("club_name") != club:
                continue
            converted = convert_row(row)
            if converted:
                rows_out.append(converted)
    return rows_out


def write_csv(rows: List[Dict[str, str]], out_path: Path) -> None:
    stat_keys = sorted({k for r in rows for k in r["scaled_stats"].keys()})
    fieldnames = [
        "name",
        "pos",
        "positions_full",
        "fifa_overall",
        "game_rating",
        "stars",
    ] + [f"stat_{k}" for k in stat_keys]
    with out_path.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for r in rows:
            row_out = {
                "name": r["name"],
                "pos": r["pos"],
                "positions_full": r["positions_full"],
                "fifa_overall": r["fifa_overall"],
                "game_rating": r["game_rating"],
                "stars": r["stars"],
            }
            for k in stat_keys:
                row_out[f"stat_{k}"] = r["scaled_stats"].get(k, "")
            writer.writerow(row_out)


def write_xml_block(rows: List[Dict[str, str]], club_name: str) -> str:
    lines = [
        '<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">',
        f'\t\t<name><![CDATA[{club_name}]]></name>',
        "\t\t<profile>90</profile>",
        "\t\t<players>",
    ]
    for r in rows:
        lines.append(
            f'\t\t\t<player id="{r["name"]}" name="{r["name"]}" birthday="{r["dob"]}" positions="{r["positions_full"]}" nationality="{r["nat"]}" number="{r["number"]}" ageImprovement="0">'
        )
        if r["pos"] == "gk":
            s = r["scaled_stats"]
            lines.append(
                f'\t\t\t\t<stats catching="{s.get("catching",0)}" shotStopping="{s.get("shot_stopping",0)}" distribution="{s.get("distribution",0)}" fitness="{s.get("keeper_fitness",0)}" stamina="{s.get("keeper_stamina",0)}"/>'
            )
        else:
            s = r["scaled_stats"]
            lines.append(
                f'\t\t\t\t<stats passing="{s.get("passing",0)}" tackling="{s.get("tackling",0)}" shooting="{s.get("shooting",0)}" crossing="{s.get("crossing",0)}" heading="{s.get("heading",0)}" dribbling="{s.get("dribbling",0)}" speed="{s.get("speed",0)}" stamina="{s.get("max_stamina",0)}" aggression="{s.get("aggression",0)}" strength="{s.get("strength",0)}" fitness="{s.get("fitness",0)}" creativity="{s.get("creativity",0)}"/>'
            )
        lines.append("\t\t\t</player>")
    lines.append("\t\t</players>")
    lines.append("\t</club>")
    return "\n".join(lines)


def main() -> None:
    if len(sys.argv) < 4:
        print("Usage: python tools/attribute_converter_bucket.py <csv> <club_name> <out.csv>")
        sys.exit(1)
    csv_path = Path(sys.argv[1])
    club_name = sys.argv[2]
    out_path = Path(sys.argv[3])

    rows = run(csv_path, club_name)
    write_csv(rows, out_path)
    print(f"Wrote {len(rows)} players to {out_path}")
    # Also print XML block to stdout for convenience
    print(write_xml_block(rows, club_name))


if __name__ == "__main__":
    main()
