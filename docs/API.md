# API Documentation

RateTheDub provides a simple read-only REST API that other's can consume for
their own purposes. This API is **intentionally limited** to properly respect the
terms of use of both [Jikan](https://jikan.moe) and
[MyAnimeList](https://myanimelist.net).

**All requests *must* have the `Accept: application/json` header!**

The API can be found at the `/api` route, so fully it would be
`https://ratethedub.com/api`.

All responses conform to the [JSON:API](https://jsonapi.org/) specification.

This API is intentionally not versioned, though is considered stable. Breaking
changes may happen infrequently, with announcements made beforehand on the
[RateTheDub Twitter account](https://twitter.com/RateTheDub).

## Locale

The RateTheDub API, unlike the main site, is **NOT** locale-aware in any way.
All API requests return the information for ALL locales and languages. There is
no locale in the URL and no redirects will be made for it.

## Caching

All responses return contain an `ETag` header which can be used to cache and
identify the response. Requests made with the `If-None-Match` header will
respond with status code 304 *and no response body* if the ETag is still current
and valid.

More information can be found
[here on Wikipedia](https://en.wikipedia.org/wiki/HTTP_ETag).

### Rate Limiting

As of now there is no rate-limiting. However this may change if needed.

## Featured Series

**Route**: `/api/featured`

Returns the anime series that are currently featured in all languages, organized
as an object with locale codes as keys and arrays of series as values.

Each language has at most 5 featured series.

#### Example

```
```

## Trending Series

**Route**: `/api/trending`

Returns the anime series that are currently trending in all languages, organized
as an object with locale codes as keys and arrays of series as values.

Each language has at most 5 trending series.

#### Example

```
```

## Top Rated Series

**Route**: `/api/top`

Returns the anime series that are currently top rated in all languages, organized
as an object with locale codes as keys and arrays of series as values.

Each language has at most 5 top rated series.

#### Example

```
```

## Anime Series

**Route**: `/api/anime/<mal_id>`

Returns the information for a single anime series with the given MyAnimeList ID.
Unlike the regular site, `GET` requests to series that do not yet exist in the
database **WILL NOT** create a new entry, and will instead respond with a 404.

#### Example

```
```
