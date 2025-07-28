CREATE TYPE gear_type AS ENUM ('container', 'rope', 'carabiner', 'acsender', 'decsender', 'harness', 'sling', 'ahd', 'pulley_set', 'patient_transport', 'rope_clamp', 'fall_arrester', 'unspecified');

CREATE TABLE gear(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    gear_type gear_type NOT NULL DEFAULT 'unspecified'::gear_type,
    mfg_date DATE,
    shelf_life INTERVAL,
    expiry_date TIMESTAMPTZ GENERATED ALWAYS AS (mfg_date + shelf_life) STORED,
    track_usage BOOLEAN NOT NULL DEFAULT FALSE,
    track_expiry BOOLEAN NOT NULL DEFAULT FALSE,
    missing BOOLEAN NOT NULL DEFAULT FALSE,
    damaged BOOLEAN NOT NULL DEFAULT FALSE,
    parent_id INTEGER  NOT NULL DEFAULT -1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    sort_order INTEGER,
);

INSERT INTO gear (name, gear_type, parent_id) VALUES 
('Bag #1', 'container'::gear_type, 0),
('Bag #2', 'container'::gear_type, 0),
('Bag #3', 'container'::gear_type, 0),
('Bag #4', 'container'::gear_type, 0),
('Vortex', 'container'::gear_type, 0),
('Terra Tamer', 'container'::gear_type, 0);

INSERT INTO gear (name, gear_type, mfg_date, shelf_life, track_usage, track_expiry, parent_id) VALUES 
('50m Rope', 'rope'::gear_type, '2024-01-01', '3 years', true, true, 1),
('CMC Clutch', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Petzl ID', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Petzl Croll Chest Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Petzl Hand Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Leg Loop', 'acsender'::gear_type, '2024-01-01', '5 years', true, true, 1),
('Petzl AMD Carabiner (Qty:10)', 'carabiner'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Full Body Harness', 'harness'::gear_type, '2024-01-01', '5 years', true, true, 1),
('Sling 10m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Sling 7m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Sling 5m (Qty:3)', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Aztek Set-of-Fours', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 1),
('Pulley (Qty:4)', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 1),

('50m Rope', 'rope'::gear_type, '2024-01-01', '3 years', true, true, 2),
('CMC Clutch', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Petzl ID', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Petzl Croll Chest Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Petzl Hand Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Leg Loop', 'acsender'::gear_type, '2024-01-01', '5 years', true, true, 2),
('Petzl AMD Carabiner (Qty:10)', 'carabiner'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Full Body Harness', 'harness'::gear_type, '2024-01-01', '5 years', true, true, 2),
('Sling 10m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Sling 7m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Sling 5m (Qty:3)', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Aztek Set-of-Fours', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 2),
('Pulley (Qty:4)', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 2),

('50m Rope', 'rope'::gear_type, '2024-01-01', '3 years', true, true, 3),
('CMC Clutch', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Petzl ID', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Petzl Croll Chest Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Petzl Hand Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Leg Loop', 'acsender'::gear_type, '2024-01-01', '5 years', true, true, 3),
('Petzl AMD Carabiner (Qty:10)', 'carabiner'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Full Body Harness', 'harness'::gear_type, '2024-01-01', '5 years', true, true, 3),
('Sling 10m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Sling 7m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Sling 5m (Qty:3)', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Aztek Set-of-Fours', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 3),
('Pulley (Qty:4)', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 3),

('50m Rope', 'rope'::gear_type, '2024-01-01', '3 years', true, true, 4),
('CMC Clutch', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Petzl ID', 'decsender'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Petzl Croll Chest Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Petzl Hand Ascender', 'acsender'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Leg Loop', 'acsender'::gear_type, '2024-01-01', '5 years', true, true, 4),
('Petzl AMD Carabiner (Qty:10)', 'carabiner'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Full Body Harness', 'harness'::gear_type, '2024-01-01', '5 years', true, true, 4),
('Sling 10m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Sling 7m', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Sling 5m (Qty:3)', 'sling'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Aztek Set-of-Fours', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 4),
('Pulley (Qty:4)', 'pulley_set'::gear_type, '2024-01-01', '10 years', true, true, 4);

CREATE TABLE activity (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    gear_type_required gear_type[], -- Array of ENUM values
    parent_id INTEGER
);

CREATE TABLE gear_usage (
  id SERIAL PRIMARY KEY,
  created_at timestamp with time zone not null default now(),
  gear_id INTEGER not null,
  activity_id INTEGER not null,
  user_id INTEGER not null
);

INSERT INTO activity (name, gear_type_required, parent_id) VALUES 
('Operation', null, null),
('Training', null, null);

INSERT INTO activity (name, gear_type_required, parent_id) VALUES 
('Passing a knot on ascend', ARRAY['rope','carabiner','acsender','rope_clamp','harness']::gear_type[], 2),
('Passing a knot on descend', ARRAY['rope','carabiner','decsender','rope_clamp','harness']::gear_type[], 2),
('Pick-off on ascend', ARRAY['rope','carabiner','acsender','decsender','rope_clamp','harness']::gear_type[], 2),
('Passing a knot on descend', ARRAY['rope','carabiner','decsender','rope_clamp','harness']::gear_type[], 2),
('General rope mobility', ARRAY['rope','carabiner','acsender','decsender','rope_clamp','harness']::gear_type[], 2),
('Edge transition', ARRAY['rope','carabiner','acsender','decsender','rope_clamp','harness']::gear_type[], 2),
('Tripod setup', ARRAY['rope','carabiner','ahd','sling']::gear_type[], 2),
('Litter setup', ARRAY['rope','carabiner','patient_transport','pulley_set','sling']::gear_type[], 2);

CREATE TABLE gear_log (
  created_at timestamp with time zone not null default now(),
  gear_id INTEGER not null,
  is_used BOOLEAN DEFAULT FALSE,
  is_damaged BOOLEAN DEFAULT FALSE,
  is_missing BOOLEAN DEFAULT FALSE,
  has_note BOOLEAN DEFAULT FALSE,
  note TEXT
);