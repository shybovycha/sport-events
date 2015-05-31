# SportEvents API

## Brief overview

This is an API for sport_events Android application. API allows for creating and searching sport events. Yep, that simple as it goes.

## API methods

### General API caveats

When everything on the server side goes fine, API method returns JSON in the format `{ success: true, ... }` where `...` stands for
additional information, method may return.

When everything is bad, method returns JSON `{ success: false, message: "..." }`. And the `message` field contains all the errors
split by semicolon sign `;`.

### `POST /users/sign_up`

**Params:**
* **name**, String, required
* **email**, String, required
* **password**, String, required
* **password_confirmation**, String, required

**Returns:**

* **api_key**, String

### `POST /users/sign_in`

**Params:**

* *email*, String, required
* *password*, String, required

**Returns:**

* **api_key**, String

### `POST /users/restore_session`

**Params:**

* **api_key**, String, required

**Returns:**

*nothing*

### `GET /events`

**Params:**

* **lat**, Float, required
* **lng**, Float, required
* **lng**, Radius, required
* **sports**, [String], required

**Returns:**

An array of these structures:

    {
        id: Integer,
        title: String,
        description: String,
        lat: Float,
        lng: Float,
        address: String,
        sport: String,
        visitors: [
            {
                name: String
            }
        ],
        created_at: DateTime
    }

### `POST /events/create`

**Params:**

* **api_key**, String, required
* **title**, String, required
* **description**, String, required
* **address**, String, required
* **sport**, String, required

**Returns:**

*nothing*