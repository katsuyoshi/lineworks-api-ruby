# Echo Bot

For example, the LINE WORKS bot echoes back messages.  

## Getting started

Download this project.  
Move to the project directory.  
Run rake command.  

```
rake install:local
```

Move to the examples/echobot directory.  

Install required gems.

```ruby
$ bundle install
```

Copy sample.env file to .env file.  
And then fill environment variables to .env file.

```
# Fill your bot configuration below and rename this file or copy to .env file.

# LINE WORKS App's Client ID
LINEWORKS_CLIENT_ID='...'
# LINE WORKS App's Service Account
LINEWORKS_SERVICE_ACCOUNT='...'
# LINE WORKS App's Client Secret
LINEWORKS_CLIENT_SECRET='...'
# LINE WORKS App's Private key
LINEWORKS_PRIVATE_KEY='...'

# LINE WORKS Bot's Secret
LINEWORKS_BOT_SECRET='...'
```

Run this example.

```
$ bundle exec ruby app.rb
```

Your app runs on port 4567.

```
https://your.base.url:4567
```

And use ngrok to publish it.

```
$ ngrok http 4567
.
.
Forwarding      https://6db9-240b-13-74e0-45f0-f1b9-b7b8-ddf2-e191.ngrok-free.app -> http://localhost
.
.
```

Set the forwarding address to the callback setting of your bot by the console of LINE WORKS.  
(in this case;  https://6db9-240b-13-74e0-45f0-f1b9-b7b8-ddf2-e191.ngrok-free.app/callback)

