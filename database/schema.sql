-- Tomica 典藏庫 V1.0.2 邏輯資料庫
-- 對齊 tomica-recognition-import：辨識資料先完整保存，再映射至典藏實體。
-- 商品／系列編號、底盤編號、包裝印刷編號永遠分離。

PRAGMA foreign_keys = ON;

CREATE TABLE master_models (
  id TEXT PRIMARY KEY,
  manufacturer TEXT NOT NULL,
  model_name TEXT NOT NULL,
  name_ja TEXT,
  name_en TEXT,
  original_name TEXT,
  vehicle_type TEXT,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE releases (
  id TEXT PRIMARY KEY,
  master_model_id TEXT NOT NULL REFERENCES master_models(id),
  series TEXT NOT NULL DEFAULT 'Tomica',
  product_series_number TEXT,
  product_code TEXT,
  jan_code TEXT,
  release_type TEXT NOT NULL DEFAULT 'standard',
  release_name TEXT,
  release_name_ja TEXT,
  release_name_en TEXT,
  color_name TEXT,
  release_date TEXT,
  release_year INTEGER,
  end_year INTEGER,
  scale_text TEXT,
  made_in TEXT,
  chassis_number TEXT,
  chassis_number_state TEXT NOT NULL DEFAULT 'unknown'
    CHECK (chassis_number_state IN ('numbered', 'none', 'unknown')),
  chassis_text_raw TEXT,
  chassis_text_normalized TEXT,
  chassis_year_marking TEXT,
  wheel_type TEXT,
  gimmicks_json TEXT,
  market_region TEXT,
  market_scope TEXT,
  market_exclusive INTEGER NOT NULL DEFAULT 0,
  market_marking_raw TEXT,
  collaboration_brand TEXT,
  license_marking TEXT,
  variation_notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE collection_items (
  id TEXT PRIMARY KEY,
  release_id TEXT REFERENCES releases(id),
  item_sequence INTEGER NOT NULL DEFAULT 1,
  provisional_name TEXT,
  ownership_status TEXT NOT NULL DEFAULT 'owned',
  data_status TEXT NOT NULL DEFAULT 'incomplete',
  body_condition TEXT,
  wheel_condition TEXT,
  chassis_condition TEXT,
  window_condition TEXT,
  interior_condition TEXT,
  overall_grade TEXT,
  acquired_date TEXT,
  acquired_source TEXT,
  acquired_price REAL,
  currency TEXT,
  storage_location TEXT,
  quantity INTEGER NOT NULL DEFAULT 1,
  notes TEXT,
  archived_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE packages (
  id TEXT PRIMARY KEY,
  collection_item_id TEXT NOT NULL REFERENCES collection_items(id),
  package_type TEXT NOT NULL,
  printed_number TEXT,
  printed_name TEXT,
  jan_code TEXT,
  product_code TEXT,
  pairing_status TEXT NOT NULL DEFAULT 'unknown',
  condition_grade TEXT,
  width_mm REAL,
  height_mm REAL,
  depth_mm REAL,
  market_marking_raw TEXT,
  package_markings_json TEXT,
  missing_parts TEXT,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE accessories (
  id TEXT PRIMARY KEY,
  collection_item_id TEXT NOT NULL REFERENCES collection_items(id),
  accessory_type TEXT,
  name TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  included_originally INTEGER,
  possession_status TEXT NOT NULL DEFAULT 'unknown',
  markings_raw TEXT,
  condition_grade TEXT,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE photos (
  id TEXT PRIMARY KEY,
  collection_item_id TEXT REFERENCES collection_items(id),
  package_id TEXT REFERENCES packages(id),
  photo_type TEXT NOT NULL,
  original_blob_key TEXT NOT NULL,
  thumbnail_blob_key TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_cover INTEGER NOT NULL DEFAULT 0,
  caption TEXT,
  captured_at TEXT,
  created_at TEXT NOT NULL,
  CHECK (collection_item_id IS NOT NULL OR package_id IS NOT NULL)
);

CREATE TABLE tags (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  color TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE item_tags (
  collection_item_id TEXT NOT NULL REFERENCES collection_items(id),
  tag_id TEXT NOT NULL REFERENCES tags(id),
  PRIMARY KEY (collection_item_id, tag_id)
);

CREATE TABLE issues (
  id TEXT PRIMARY KEY,
  collection_item_id TEXT NOT NULL REFERENCES collection_items(id),
  issue_type TEXT NOT NULL,
  severity TEXT NOT NULL DEFAULT 'info',
  status TEXT NOT NULL DEFAULT 'open',
  title TEXT NOT NULL,
  description TEXT,
  resolution TEXT,
  created_at TEXT NOT NULL,
  resolved_at TEXT
);

CREATE TABLE app_metadata (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE INDEX idx_releases_product_number ON releases(product_series_number);
CREATE INDEX idx_releases_jan ON releases(jan_code);
CREATE INDEX idx_releases_product_code ON releases(product_code);
CREATE INDEX idx_releases_chassis_number ON releases(chassis_number);
CREATE INDEX idx_releases_model ON releases(master_model_id);
CREATE INDEX idx_releases_market ON releases(market_region, market_scope, market_exclusive);
CREATE INDEX idx_items_release ON collection_items(release_id);
CREATE INDEX idx_items_status ON collection_items(ownership_status, data_status);
CREATE INDEX idx_items_updated ON collection_items(updated_at);
CREATE INDEX idx_packages_item ON packages(collection_item_id);
CREATE INDEX idx_accessories_item ON accessories(collection_item_id);
CREATE INDEX idx_photos_item ON photos(collection_item_id);
CREATE INDEX idx_issues_item_status ON issues(collection_item_id, status);
