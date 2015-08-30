# SportEvents API

## Brief overview

This is an API for sport_events Android application. API allows for creating and searching sport events. Yep, that simple as it goes.

## API methods

### General API caveats

When everything on the server side goes fine, API method returns JSON in the format `{ success: true, ... }` where `...` stands for
additional information, method may return.

When everything is bad, method returns JSON `{ success: false, message: "..." }`. And the `message` field contains all the errors
split by semicolon sign `;`.

### `GET /users`

**Description:**

Gets user's account data.

**Params:**
* **api_key**, String, required

**Returns:**

    {
      name: String,
      email: String,
      address: String,
      facebook_id: String,
      sports: String (joined by comma)
    }

### `POST /users/update`

**Description:**

Updates user's account data with the new values.

**Params:**
* **api_key**, String, required
* **name**, String, required
* **email**, String, required
* **address**, String, required

**Returns:**

*nothing*

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
        created_at: DateTime,
        starts_at: DateTime
    }

In case of grouping with `group_by` field:

    {
      group: String,
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
      created_at: DateTime,
      starts_at: DateTime
    }

### `GET /events/for_user`

**Description:**

Returns a list of events for the specified user.

**Params:**

* **api_key**, String, required
* **group_by**, String, optional

**Returns:**

Returns data in the same format as for `GET /events`

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

### `GET /events/join`

**Description:**

Joins current user to an event, so he will appear in `visitors` list of event.

**Params:**

* **api_key**, String, required
* **event_id**, String, required

**Returns:**

*nothing*

### `GET /events/leave`

**Description:**

Removes current user from event attendees, so he will **not** appear in `visitors` list of event.

**Params:**

* **api_key**, String, required
* **event_id**, String, required

**Returns:**

*nothing*
