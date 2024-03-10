# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# If there are issues with resetting the int primary key for the database tables, recreate the database first before seeding it with the following commands:
# - `bin/rails db:drop:_unsafe`
# - `bin/rails setup`
# - `bin/rails seed`

# Create initial data
Photo.create({ image_name: "photo_1.png" })

PhotoObject.create([
	{
    photo_id: 1,
		name: "Waldo",
		image_name: "object_waldo.png",
		top_left_x: 733,
		top_left_y: 457,
		bot_right_x: 767,
		bot_right_y: 507,
	},
	{
    photo_id: 1,
		name: "Wenda",
		image_name: "object_wenda.png",
		top_left_x: 425,
		top_left_y: 371,
		bot_right_x: 438,
		bot_right_y: 393,
	},
	{
		photo_id: 1,
		name: "Woof (His Tail)",
		image_name: "object_woof.png",
		top_left_x: 708,
		top_left_y: 252,
		bot_right_x: 719,
		bot_right_y: 263
	},
])

Score.create([
  {
    photo_id: 1,
    player_name: "GamerGuy99",
    run_length_in_ms: 12369420
  },
  {
    photo_id: 1,
    player_name: "h_a_c_k_e_r_m_a_n",
    run_length_in_ms: 1
  },
  {
    photo_id: 1,
    player_name: "BRUH.wav",
    run_length_in_ms: 16812
  },
])
