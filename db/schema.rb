# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140101212257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "burgers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "buns"
    t.string   "patties"
    t.string   "cheese"
    t.string   "onions"
    t.string   "tomatoes"
    t.string   "lettuce"
    t.string   "spreads"
    t.string   "others"
    t.string   "cutinhalf"
    t.text     "cooklevel"
    t.text     "heavymustardbeef"
    t.text     "normalmustardbeef"
    t.text     "normalbeef"
    t.text     "nosaltbeef"
    t.text     "coldcheese"
    t.text     "meltcheese"
    t.text     "rawwholeonions"
    t.text     "rawchoponions"
    t.text     "grillwholeonions"
    t.text     "grillchoponions"
    t.integer  "sumbeef"
    t.integer  "sumcheese"
    t.integer  "sumonions"
    t.text     "spread"
    t.text     "mustard"
    t.text     "ketchup"
    t.text     "extrasalt"
    t.text     "pickles"
    t.text     "chopchillies"
    t.text     "condiments"
    t.text     "specialrequests"
    t.text     "animalstyle"
    t.text     "result"
    t.text     "code"
    t.text     "frystyle"
    t.text     "beefcount"
    t.text     "cheesestyle"
    t.text     "cheesecount"
    t.text     "onionstyle"
    t.text     "onioncount"
    t.text     "onion1"
    t.text     "onion2"
    t.text     "onion3"
    t.text     "onion4"
  end

  create_table "comments", force: true do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "paths"
    t.string   "directions"
    t.string   "commands"
    t.string   "scanresults"
  end

end
