# Specs

Table Of Contents:

- [Data Models](#data-models)
  - [Photo](#photo-data-model)
  - [PhotoObject](#photoobject-data-model)
  - [Score](#score-data-model)
  - [Game](#game-data-model)
- [Resource APIs](#resource-apis)
  - [Photo](#photo-resource-api)
  - [PhotoObject](#photoobject-resource-api)
  - [Score](#score-resource-api)
  - [Game](#game-resource-api)

## Data Models

### `Photo` Data Model

```
image_name:string [present]
id:integer
created_at:datetime
updated_at:datetime

has_many photo_objects
has_many scores
```

### `PhotoObject` Data Model

```
name:string [present]
image_name:string [present]
top_left_x:integer [present]
top_left_y:integer [present]
bot_right_x:integer [present]
bot_right_y:integer [present]
photo_id:integer [present] (FK of `Photo.id`)
id:integer
created_at:datetime
updated_at:datetime

belongs_to photo
```

### `Score` Data Model

```
player_name:string [present]
run_length_in_ms:integer [present]
photo_id:integer [present] (FK of `Photo.id`)
id:integer
created_at:datetime
updated_at:datetime

belongs_to photo
```

### `Game` Data Model

Notes:

- This "model" does not map to a database table.
- This "model" only exists as a session stored in a cookie.

```
session_id:string [present] (autogenerated by the server)
is_over:boolean [present]
did_update_start:boolean [present]
photo_id:integer [present]
found_object_ids:integer[] [present] (integer array)
start_in_ms:integer [present]
end_in_ms:integer [present]
```

## Resource APIs

The routes, requests, and responses for each resource available to the web API endpoint.

### `Photo` Resource API

#### `GET /photos/:id` Route

Example Request:

```bash
# Query Params
GET http://localhost:3000/photos/1
```

Example Response:

```json
{
  "id": 1,
  "image_url": "http://localhost:3000/photo_1.png"
}
```

### `PhotoObject` Resource API

#### `GET /photos/:photo_id/photo_objects` Route

Example Request:

```bash
# Query Params
GET http://localhost:3000/photos/1/photo_objects
```

Example Response:

```json
[
  {
    "id": 1,
    "name": "Waldo",
    "image_url": "http://localhost:3000/object_waldo.png"
  },
  {
    "id": 2,
    "name": "Wenda",
    "image_url": "http://localhost:3000/object_wenda.png"
  },
  {
    "id": 3,
    "name": "Woof (His Tail)",
    "image_url": "http://localhost:3000/object_woof.png"
  }
]
```

### `Score` Resource API

#### `GET /photos/:photo_id/scores` Route

Example Request:

```bash
# Query Params
GET http://localhost:3000/photos/1/scores
```

Example Response:

```json
[
  {
    "id": 2,
    "player_name": "h_a_c_k_e_r_m_a_n",
    "run_length_in_ms": 1
  },
  {
    "id": 3,
    "player_name": "BRUH.wav",
    "run_length_in_ms": 16812
  },
  {
    "id": 1,
    "player_name": "GamerGuy99",
    "run_length_in_ms": 12369420
  }
]
```

#### `POST /photos/:photo_id/scores` Route

##### Success

Example Request:

```bash
# Query Params
POST http://localhost:3000/photos/1/scores

# Body Params
{
  "player_name": "GamerGuy99"
}
```

Example Response:

```json
{
  "id": 1,
  "player_name": "GamerGuy99",
  "photo_id": 1,
  "created_at": "Sun, 10 Mar 2024 22:11:20.157022000 UTC +00:00",
  "updated_at": "Sun, 10 Mar 2024 22:11:20.157022000 UTC +00:00",
  "run_length_in_ms": 12369420
}
```

##### Error 1 - no game session

Example Request:

```bash
# Query Params
POST http://localhost:3000/photos/1/scores

# Body Params
{
  "player_name": "GamerGuy99"
}
```

Example Response:

```json
{
  "error": {
    "title": "Failed to create score",
    "message": "Game session does not exist"
  }
}
```

##### Error 2 - game session not over

Example Request:

```bash
# Query Params
POST http://localhost:3000/photos/1/scores

# Body Params
{
  "player_name": "GamerGuy99"
}
```

Example Response:

```json
{
  "error": {
    "title": "Failed to create score",
    "message": "Game session is not over"
  }
}
```

### `Game` Resource API

#### `POST /games` Route

Notes:

- Server creates new game session

Example Request:

```bash
# Body Params
{
  "photo_id": 1
}
```

Example Response:

```json
{
  "session_id": "961747ac552547f70439dffac75e28b9",
  "is_over": false,
  "did_update_start": false,
  "photo_id": 1,
  "object_count": 3,
  "found_object_ids": [],
  "start_in_ms": 1710112000461,
  "end_in_ms": -1
}
```

#### `PATCH /games/:id` Route

Notes:

- Passed `:id` query param does not matter as long it is some valid character that matches the route pattern.

##### Success - Server updates start time for client

Example Request:

```bash
# Query Params
PATCH http://localhost:3000/games/:id

# Body Params
{
  "did_update_start": false,
  "timestamp_in_ms": 1710112108851
}
```

Example Response:

```json
{
  "session_id": "961747ac552547f70439dffac75e28b9",
  "is_over": false,
  "did_update_start": true,
  "photo_id": 1,
  "object_count": 3,
  "found_object_ids": [],
  "start_in_ms": 1710112108851,
  "end_in_ms": -1
}
```

##### Success - Server updates game session on a successful client guess

Example Request:

```bash
# Query Params
PATCH http://localhost:3000/games/:id

# Body Params
{
  "timestamp_in_ms": 1710112197306,
  "did_update_start": true,
  "object_id": 3,
  "target_x": 715,
  "target_y": 258
}
```

Example Response:

```json
{
  "session_id": "961747ac552547f70439dffac75e28b9",
  "is_over": false,
  "did_update_start": true,
  "photo_id": 1,
  "object_count": 3,
  "found_object_ids": [3],
  "start_in_ms": 1710112197306,
  "end_in_ms": -1
}
```

#### `DELETE /games/:id` Route

Notes:

- Passed `:id` query param does not matter as long it is some valid character that matches the route pattern.

Example Request:

```bash
# Query Params
PATCH http://localhost:3000/games/:id
```

Example Response:

```json
{
  "session_id": "961747ac552547f70439dffac75e28b9"
}
```