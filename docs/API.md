# API Documentation

RateTheDub provides a simple read-only REST API that other's can consume for
their own purposes. This API is **intentionally limited** to properly respect the
terms of use of both [Jikan](https://jikan.moe) and
[MyAnimeList](https://myanimelist.net).

**All requests _must_ have the `Accept: application/json` header!**

The API can be found at the `/api` route, so fully it would be
`https://ratethedub.com/api`.

All responses conform to the [JSON:API](https://jsonapi.org/) specification.

This API is intentionally not versioned, though is considered stable. Breaking
changes may happen infrequently, with announcements made beforehand on the
[RateTheDub Twitter account](https://twitter.com/RateTheDub).

As of now there is no caching or rate-limiting, though these may be added in the
future if deemed necessary.

## Locale

The RateTheDub API, unlike the main site, is **NOT** locale-aware in any way.
All API requests return the information for ALL locales and languages. There is
no locale in the URL and no redirects will be made for it.

## Root

**Route**: `/api/`

Returns an empty object with the JSON:API meta attributes. Useful for
debugging/testing but not much else

#### Example Response

```js
{
  "data": {},
  "jsonapi": {
    "version": "1.0"
  },
  "links": {
    "self": "https://ratethedub.com/"
  }
}
```

## Featured Series

**Route**: `/api/featured`

Returns the anime series that are currently featured in all languages, organized
as an object with locale codes as keys and arrays of series as values.

Each language has at most 5 featured series.

#### Example Response

```js
{
  "data": [
    {
      "attributes": {
        "language": "en",
        "mal_id": 1,
        "votes": 2
      },
      "id": 1,
      "links": {
        "self": "https://ratethedub.com/en/anime/1"
      },
      "type": "series_lang_votes"
    }
  ],
  "jsonapi": {
    "version": "1.0"
  },
  "links": {
    "self": "https://ratethedub.com/"
  }
}
```

## Trending Series

**Route**: `/api/trending`

Returns the anime series that are currently trending in all languages, organized
as an object with locale codes as keys and arrays of series as values.

Each language has at most 5 trending series.

#### Example Response

``` js
{
  data: [
    {
      "attributes": {
        "language": "pt_BR",
        "mal_id": 6,
        "votes": 6
      },
      "id": 6,
      "links": {
        "self": "https://ratethedub.com/pt_BR/anime/6"
      },
      "type": "series_lang_votes"
    },
    {
      "attributes": {
        "language": "pt_BR",
        "mal_id": 5114,
        "votes": 5
      },
      "id": 5114,
      "links": {
        "self": "https://ratethedub.com/pt_BR/anime/5114"
      },
      "type": "series_lang_votes"
    }
  ],
  "jsonapi": {
    "version": "1.0"
  },
  "links": {
    "self": "https://ratethedub.com/"
  }
}
```

## Top Rated Series

**Route**: `/api/top`

Returns the anime series that are currently top rated in all languages, organized
as an object with locale codes as keys and arrays of series as values.

Each language has at most 5 top rated series.

#### Example Response

```js
{
  "data": [
    {
      "attributes": {
        "language": "es",
        "mal_id": 5152,
        "votes": 3
      },
      "id": 5152,
      "links": {
        "self": "https://ratethedub.com/es/anime/5152"
      },
      "type": "series_lang_votes"
    },
    {
      "attributes": {
        "language": "es",
        "mal_id": 1,
        "votes": 1
      },
      "id": 1,
      "links": {
        "self": "https://ratethedub.com/es/anime/1"
      },
      "type": "series_lang_votes"
    },
    {
      "attributes": {
        "language": "en",
        "mal_id": 1,
        "votes": 2
      },
      "id": 1,
      "links": {
        "self": "https://ratethedub.com/en/anime/1"
      },
      "type": "series_lang_votes"
    }
  ],
  "jsonapi": {
    "version": "1.0"
  },
  "links": {
    "self": "https://ratethedub.com/"
  }
}
```

## Anime Series

**Route**: `/api/anime/<mal_id>`

Returns the information for a single anime series with the given MyAnimeList ID.
Unlike the regular site, `GET` requests to series that do not yet exist in the
database **WILL NOT** create a new entry, and will instead respond with a 404.

#### Example Response

``` js
{
  "data": {
    "attributes": {
      "dubbed_in": [
        "ja",
        "en",
        "fr",
        "es",
        "ko",
        "it",
        "de",
        "hu"
      ],
      "mal_id": 1,
      "votes": {
        "de": 0,
        "en": 2,
        "es": 1,
        "fr": 0,
        "hu": 0,
        "it": 0,
        "ja": 0,
        "ko": 0
      }
    },
    "id": 1,
    "links": {
      "self": "https://ratethedub.com/anime/1"
    },
    "type": "anime_series"
  },
  "jsonapi": {
    "version": "1.0"
  },
  "links": {
    "self": "https://ratethedub.com/"
  }
}
```
