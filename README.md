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

**Description:**

Creates a new user in database. Used on first application run, when user does not have an account.

**Params:**
* **name**, String, required
* **email**, String, required
* **password**, String, required
* **password_confirmation**, String, required

**Returns:**

* **api_key**, String

### `POST /users/sign_in`

**Description:**

User logging in. Used on first application run, when user has an account already.

**Params:**

* *email*, String, required
* *password*, String, required

**Returns:**

* **api_key**, String

### `POST /users/restore_session`

**Description:**

Logs user in after application was closed. Does not require user's credentials and login form - the `api_key` only, which must be stored in application's data, after user logs in or account created.

**Params:**

* **api_key**, String, required

**Returns:**

*nothing*

### `GET /events`

**Description:**

Returns a list of events around the location.
Query - a set of keywords, divided by spaces.
Sports - list of sports desired, separated by a comma.

**Params:**

* **address**, String, required
* **query**, Float, optional
* **radius**, Radius, optional
* **sports**, String, optional

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

**Description:**

Creates a new event in the system.

**Params:**

* **api_key**, String, required
* **title**, String, required
* **description**, String, required
* **address**, String, required
* **sport**, String, required

**Returns:**

*nothing*
