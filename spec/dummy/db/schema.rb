# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_01_150509) do
  create_table "fasp_client_providers", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "base_url"
    t.string "server_id"
    t.string "public_key"
    t.string "ed25519_signing_key"
    t.integer "status"
    t.json "capabilities"
    t.json "privacy_policy"
    t.string "sign_in_url"
    t.string "contact_email"
    t.string "fediverse_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
