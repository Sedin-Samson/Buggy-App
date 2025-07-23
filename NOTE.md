# Rails Application Bug Fixes Documentation

## Bug Fixes

### 1. Bundle Install Error - "boot-snap" Gem Issue

**Problem:**
- Error occurred during `bundle install` related to "boot-snap" gem
- Gem name was incorrectly specified

**Solution:**
- Changed gem name from `"boot-snap"` to `"bootsnap"`
- The correct gem name is `bootsnap` (without hyphen)

---

### 2. Assets Configuration Typo

**Problem:**
- Configuration error in assets initialization file
- Extra 's' in `assetss.version`

**Solution:**
- Fixed typo in `config/initializers/assets.rb` at line 4
- Changed from: `Rails.application.config.assetss.version = "1.0"`
- Changed to: `Rails.application.config.assets.version = "1.0"`

---

### 3. Production Environment Configuration Typo

**Problem:**
- Typo in production environment configuration
- `confgure` instead of `configure`

**Solution:**
- Fixed typo in `config/environments/production.rb` at line 3
- Changed from: `confgure`
- Changed to: `configure`

---

### 4. Missing Secret Key Base for Production Environment

**Problem:**
- Error when running `rails db:create`
- Missing `secret_key_base` for production environment

**Solution:**
- Run the following command to create production credentials:
  ```bash
  EDITOR="nano" bin/rails credentials:edit --environment production
  ```

**What this command does:**
- Opens the production credentials file in nano editor
- Creates two files if they don't exist:
  - `config/credentials/production.key`
  - `config/credentials/production.yml.enc`
- Allows you to set the `secret_key_base` for production environment

---

### 5. MySQL Database Configuration

**Problem:**
- Need to configure MySQL as the database for the Rails application
- Missing MySQL adapter gem in Gemfile

**Solution:**
- Add the MySQL2 gem to the Gemfile:
  ```ruby
  gem 'mysql2', '>= 0.5'
  ```
- Run `bundle install` after adding the gem