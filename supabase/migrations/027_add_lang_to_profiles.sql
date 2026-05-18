ALTER TABLE profiles ADD COLUMN IF NOT EXISTS lang text DEFAULT 'en';
COMMENT ON COLUMN profiles.lang IS 'User language preference: en or fr-CA';
