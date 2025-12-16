# Attribute Converter (FM 1–20 → Game 1–100)

This document contains Excel-ready formulas to convert **Football Manager (FM) 1–20** attribute values into your game’s **1–100** scale.

---

## 1) Simple linear mapping (clean + predictable)

Maps **FM 1 → 1** and **FM 20 → 100**.

**Excel (FM value in `A2`):**
```excel
=ROUND(1 + (A2-1)*99/19, 0)
```

---

## 2) Power curve mapping (high end more valuable)

This makes top-end attributes stand out more than mid-range values.

**Excel (FM value in `A2`):**
```excel
=ROUND(1 + 99*POWER((A2-1)/19, 1.35), 0)
```

**Tuning:**
- Increase `1.35` (e.g. `1.5`) to make elite values pop more.
- Decrease toward `1.0` to approach linear.

---

## 3) Soft S-curve mapping (middle clusters, extremes stand out)

Useful if you want **8–14** to cluster while **17–20** feel special.

**Excel with `LET` (FM value in `A2`):**
```excel
=LET(x,(A2-10.5)/3, ROUND(1 + 99*(1/(1+EXP(-x))), 0))
```

**Excel without `LET`:**
```excel
=ROUND(1 + 99*(1/(1+EXP(-((A2-10.5)/3)))), 0)
```

**Tuning:**
- Change `/3` to `/2.5` for a steeper curve (more extreme separation).
- Change `/3` to `/3.5` for a gentler curve.

---

## Bonus: Weighted FM attributes → single 1–100 stat

If you combine multiple FM attributes (each **1–20**) into one of your game attributes:

### Step 1 — Compute a weighted FM average (still on 1–20)
Assume:
- FM attribute values are in `A2:E2`
- Weights are in `A1:E1`

```excel
=SUMPRODUCT(A2:E2, A$1:E$1)/SUM(A$1:E$1)
```

### Step 2 — Convert the weighted FM average to 1–100
If the weighted FM average is in `F2`, convert using (example: linear):

```excel
=ROUND(1 + (F2-1)*99/19, 0)
```

---

## Suggested workflow

1. Calculate each derived attribute’s **weighted FM average**.
2. Apply your chosen conversion curve (linear / power / S-curve).
3. Round to an integer (or remove rounding if you want decimals).

