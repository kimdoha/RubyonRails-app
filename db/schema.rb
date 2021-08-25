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

ActiveRecord::Schema.define(version: 2021_08_25_122924) do

  create_table "PostImage", primary_key: "imageId", id: { comment: "게시글이미지인덱스" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "게시글이미지TB", force: :cascade do |t|
    t.bigint "postId", null: false, comment: "게시글인덱스"
    t.text "imageUrl", null: false, comment: "이미지주소"
    t.integer "main", limit: 1, default: 0, null: false, comment: "메인 : 1 | 아니면 0"
    t.string "status", limit: 1, default: "Y", null: false, comment: "활성상태"
  end

  create_table "alarms", id: { comment: "알람인덱스" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "키워드알림TB", force: :cascade do |t|
    t.bigint "user_id", default: 1, null: false, comment: "유저인덱스"
    t.bigint "post_id", null: false, comment: "게시글인덱스"
    t.timestamp "create_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "일림생성날짜"
    t.integer "keyword_id"
  end

  create_table "keywords", id: { comment: "키워드인덱스" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "키워드TB", force: :cascade do |t|
    t.bigint "user_id", default: 1, null: false, comment: "유저인덱스"
    t.string "keyword", limit: 45, null: false, comment: "키워드"
    t.timestamp "create_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "키워드생성날짜"
  end

  create_table "posts", id: { comment: "게시글인덱스" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "게시글TB", force: :cascade do |t|
    t.bigint "user_id", default: 1, null: false, comment: "유저인덱스"
    t.string "title", limit: 100, null: false, comment: "글제목"
    t.string "content", limit: 5000, null: false, comment: "글내용"
    t.string "status", limit: 1, default: "Y", null: false, comment: "활성상태"
    t.timestamp "create_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "게시글생성날짜"
    t.timestamp "update_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "게시글수정날짜"
    t.text "image_url"
  end

  create_table "users", id: { comment: "유저인덱스" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "유저TB", force: :cascade do |t|
    t.string "nick_name", limit: 45, null: false, comment: "닉네임"
    t.string "status", limit: 1, default: "Y", null: false, comment: "활성상태"
    t.timestamp "create_at", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "유저생성날짜"
    t.timestamp "update_at", default: -> { "CURRENT_TIMESTAMP" }, comment: "유저수정날짜"
    t.integer "alarm"
  end

end
