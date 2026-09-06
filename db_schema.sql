-- Table 1: fine-grained snapshots, one row every 15 minutes
-- Kept for ~30-35 days, then old rows are deleted automatically
-- (their data has already been folded into gold_rate_daily_summary by then)
CREATE TABLE latest_gold_rates (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  timestamp TEXT NOT NULL,       -- when this snapshot was taken (ISO 8601, UTC)
  karat_24_buy REAL NOT NULL,    -- 24K buy price, LKR per gram
  karat_24_sell REAL NOT NULL,   -- 24K sell price, LKR per gram
  karat_22_buy REAL NOT NULL,    -- 22K buy price, LKR per gram
  karat_22_sell REAL NOT NULL,   -- 22K sell price, LKR per gram
  xau_usd REAL NOT NULL,         -- raw gold spot price, USD per troy ounce
  usd_lkr REAL NOT NULL          -- USD to LKR exchange rate used for this snapshot
);

-- Index to make "give me the last N days" queries fast as this table grows
CREATE INDEX idx_latest_gold_rates_timestamp ON latest_gold_rates(timestamp);

-- Table 2: one row per calendar day, kept for up to 5 years
-- Built by summarizing that day's rows from latest_gold_rates before they age out
CREATE TABLE gold_rate_daily_summary (
  date TEXT PRIMARY KEY,           -- the calendar day, e.g. '2026-09-06'
  karat_22_avg REAL NOT NULL,      -- average 22K sell price that day
  karat_22_high REAL NOT NULL,     -- highest 22K sell price that day
  karat_22_low REAL NOT NULL,      -- lowest 22K sell price that day
  karat_24_avg REAL NOT NULL,      -- average 24K sell price that day
  karat_24_high REAL NOT NULL,     -- highest 24K sell price that day
  karat_24_low REAL NOT NULL       -- lowest 24K sell price that day
);

-- Index to make "give me the last N years" queries fast as this table grows
CREATE INDEX idx_gold_rate_daily_summary_date ON gold_rate_daily_summary(date);
