# Read Me

- *[Introduction](#introduction)*
- *[Tasks](#Tasks)*
- *[Evaluation](#Evaluation)*


## Introduction
Hello, and welcome.

To further your application process, we need you to write a sample app that will display Airports and give us time references. This will challenge your ability to connect to APIs, to think about displaying and filtering large amounts of datas, and send them to a distant server. 

## Tasks
You will `GET` the flux `http://middle.openjetlab.fr/api/rests/airport/list` from our MiddleWare, and build an app around it.

We expect a **display** of the list per Region -see schema below- *(this strongly implies that you will need to connect to another API to locate your airport)*. There are more than 21 000 airports in it, you will need to be smart about it. What filters will you use ?

An airport contains these details:
```json
{
  "lfi": "SP80307",
  "icao": "LECO",
  "iata": "LCG",
  "faaCode": null,
  "name": "A CORUNA",
  "city": "LA CORUNA",
  "countryCode": "ES",
  "latitudeDecimal": "43.3020611",
  "longitudeDecimal": "-8.3772556",
  "utcStdConversion": "+1"
}
```
You need to **validate** that the data you receive will conform to this.

On your list, the user will be able to **select** or **search** for an airport.

When doing so, you will send a `POST` request to `http://candidat.openjetlab.fr/` with three elements : the `city` of the chosen airport, the `airport` itself, and the `timezone` of the city in the [iso8601 Format](http://www.w3.org/TR/NOTE-datetime).
##### Explanation :
```
A JSON encoded date looks like this:

"2014-01-01T23:28:56.782Z"

The date is represented in a standard and sortable format that represents a UTC time (indicated by the Z).
ISO 8601 also supports time zones by replacing the Z with + or – value for the timezone offset:

"2014-02-01T09:28:56.321-10:00"
```

You will receive mail updates (server-sent) when you successfully do so.


#### In short:
- `GET` the list, and assert that it conforms with the attended model.
- **Display** it by Region :
```
└ Continent
      └ Country
          └ City
            └ Airport 1
            └ Airport 2
            └ ...
```
- An user can **Search** for an airport..
- Or **Select** it from the list.
- Selecting an airport will `POST` it to our server.
- The server will expect 3 values :
  - `city`
  - `airport`
  - `timezone` *the difference of time between the city and UTC+0*

## Evaluation
We will especially check:
- The cleanliness of your code.
- The speed of your execution.
- The readability.
- What libraries you use or not.
- How you commit.

Any bonus, or particularly well-thought UX and UI will be greatly appreciated. Of course, we do not expect you to do a designer's work, be practical.

We are looking for fast and efficient candidates, who can work well with others.

Thank you for your time, and *good luck* !
