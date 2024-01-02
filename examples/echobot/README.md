# Echo Bot

An example LINE WORKS bot just to echo messages

## Getting started

Install required gems.

```ruby
$ bundle install
```

Copy .env.sample file to .env file.  
And then fill environment variables to .env file.

```
```

Run this example.

```
$ bundle exec ruby app.rb
```

Your app runs on port 4567.

```
https://your.base.url:4567/callback
```

And use ngrok to publish it.

```
$ ngrok http 4567
.
.
Forwarding                    https://6db9-240b-13-74e0-45f0-f1b9-b7b8-ddf2-e191.ngrok-free.app -> http://localhost
.
.
```

Set the forwarding address to the callback setting of your bot by the console of LINE WORKS


