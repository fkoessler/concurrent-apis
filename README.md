# README

# Installation

* `docker-compose up`
* `bin/rails db:create db:migrate`
* `bin/rails db:seed`
* `bin/dev`

# Versions
* on the main branch, search results are streamed using Turbo Streams over WebSockets (ActionCable)
* on the server-sent-events branch, search results are streamed using Turbo Streams over Server-Sent Events (HTTP)