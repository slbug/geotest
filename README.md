# README

create `.env` file with content

```
GEOCODER_API_KEY=<ipstack api key>
```

run:

```
docker compose build
docker compose run web rails db:create db:migrate
docker compose up
```

create user:

```
docker compose run web rails console

User.create!(email: '<email>', password: '<password>'`
```

get basic auth:

```
Base64.encode64('<email>:<password>').strip
```

send requests like this:

`curl -H 'Authorization: Basic <basic auth>' -H 'Content-Type: application/json' -XPOST -d '{"input":"8.8.8.8"}' http://localhost:8080/geo_datum`

`curl -H 'Authorization: Basic <basic auth>' -H 'Content-Type: application/json' -XGET -d '{"input":"8.8.8.8"}' http://localhost:8080/geo_datum`

`curl -H 'Authorization: Basic <basic auth>' -H 'Content-Type: application/json' -XDELETE -d '{"input":"8.8.8.8"}' http://localhost:8080/geo_datum`
