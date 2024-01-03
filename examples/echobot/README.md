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

Copy .env.sample file to .env file.  
And then fill environment variables to .env file.

```
# LINE WORKS's Bot Secret
LINE_WORKS_BOT_SECRET='...'

# You need to get an access token first.
# There is an article about how to get an access token using Postman. Please refer to it.
# @see: https://qiita.com/mmclsntr/items/eee8d8f3546410fe6652
LINE_WORKS_ACCESS_TOKEN='...'
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
Forwarding      https://6db9-240b-13-74e0-45f0-f1b9-b7b8-ddf2-e191.ngrok-free.app -> http://localhost
.
.
```

Set the forwarding address to the callback setting of your bot by the console of LINE WORKS.  
(in this case;  https://6db9-240b-13-74e0-45f0-f1b9-b7b8-ddf2-e191.ngrok-free.app/callback)

