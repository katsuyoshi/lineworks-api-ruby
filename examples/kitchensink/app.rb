require 'sinatra'   # gem 'sinatra'
require 'lineworks'  # gem 'line-bot-api'
require 'dotenv'        # gem 'dotenv'

Dotenv.load

THUMBNAIL_URL = 'https://via.placeholder.com/1024x1024'
HORIZONTAL_THUMBNAIL_URL = 'https://via.placeholder.com/1024x768'
QUICK_REPLY_ICON_URL = 'https://via.placeholder.com/64x64'

set :app_base_url, ENV['APP_BASE_URL']

include Lineworks::Bot::Message

def client
  @client ||= Lineworks::Client.new do |config|
    config.channel_id = ENV['LINEWORKS_CLIENT_ID']
    config.channel_secret = ENV['LINEWORKS_CLIENT_SECRET']
    config.service_account = ENV['LINEWORKS_SERVICE_ACCOUNT']
    config.bot_secret = ENV['LINEWORKS_BOT_SECRET']
    config.private_key = ENV['LINEWORKS_PRIVATE_KEY']
    config.http_options = {
      open_timeout: 5,
      read_timeout: 5,
    }
  end
  @client.tap do |c|
    c.update_access_token 'bot user.read'
  end
end

def reply_text(bot_id, event, text)
  client.send_messages_to_channel(
    bot_id,
    event.channel_id,
    text
  )
end

def broadcast(messages)
  client.broadcast(messages)
end

def reply_content(bot_id, event, content)
  res = client.send_messages_to_channel(
    bot_id,
    event.channel_id,
    content.to_h
  )
  logger.warn res.read_body unless Net::HTTPOK === res
  res
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_WORKS_SIGNATURE']
  error 400 do 'Bad Request' end unless client.validate_signature(body, signature)

  bot_id = request.env['HTTP_X_WORKS_BOTID']
  event = client.parse_event_from(body)

  case event
  when Lineworks::Bot::Event::Message
    handle_message(bot_id, event)

  when Lineworks::Bot::Event::Joined
    reply_text(bot_id, event, "[JOINED]\nThank you for joined")

  when Lineworks::Bot::Event::Left
    logger.info "[LEFT]\n#{body}"

  when Lineworks::Bot::Event::Join
    reply_text(bot_id, event, "[JOIN]\n#{event['source']['type']}")

  when Lineworks::Bot::Event::Leave
    logger.info "[LEAVE]\n#{body}"

  when Lineworks::Bot::Event::Postback
    message = "[POSTBACK]\n#{event.data} (#{JSON.generate(event.data)})"
    reply_text(bot_id, event, message)

=begin
  when Lineworks::Bot::Event::Beacon
    reply_text(bot_id, event, "[BEACON]\n#{JSON.generate(event['beacon'])}")

  when Lineworks::Bot::Event::Things
    reply_text(bot_id, event, "[THINGS]\n#{JSON.generate(event['things'])}")

  when Lineworks::Bot::Event::VideoPlayComplete
    reply_text(bot_id, event, "[VIDEOPLAYCOMPLETE]\n#{JSON.generate(event['videoPlayComplete'])}")

  when Lineworks::Bot::Event::Unsend
    handle_unsend(bot_id, event)
=end

  else
    reply_text(bot_id, event, "Unknown event type: #{event}")
  end

  "OK"
end

def handle_message(bot_id, event)
  case event.type
  when Lineworks::Bot::Event::MessageType::Image
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body)
    reply_text(bot_id, event, "[MessageType::IMAGE]\nid:#{message_id}\nreceived #{tf.size} bytes data")
=begin
  # CHECKME: Video is not supported in LINEWORKS, right?
  when Lineworks::Bot::Event::MessageType::Video
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body)
    reply_text(bot_id, event, "[MessageType::VIDEO]\nid:#{message_id}\nreceived #{tf.size} bytes data")
  when Lineworks::Bot::Event::MessageType::Audio
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body)
    reply_text(bot_id, event, "[MessageType::AUDIO]\nid:#{message_id}\nreceived #{tf.size} bytes data")
=end
  when Lineworks::Bot::Event::MessageType::File
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body) 
    reply_text(bot_id, event, "[MessageType::FILE]\nid:#{message_id}\nfileName:#{event.message['fileName']}\nfileSize:#{event.message['fileSize']}\nreceived #{tf.size} bytes data")
  when Lineworks::Bot::Event::MessageType::Sticker
    handle_sticker(event)
  when Lineworks::Bot::Event::MessageType::Location
    handle_location(bot_id, event)
  when Lineworks::Bot::Event::MessageType::Text
    case event.message['text']
    when 'profile'
      if event['source']['userId']
        profile = client.get_profile_content(event['source']['userId'])
        reply_text(bot_id, event, 
          "User name\n#{profile[:userName][:lastName]} #{profile[:userName][:firstName]}"
        )
      else
        reply_text(bot_id, event, "Bot can't use profile API without user ID")
      end

=begin
    # CHECKME: emoji is not supported in LINE WORKS, right?
    when 'emoji'
      reply_content(bot_id, event, {
        type: 'text',
        text: 'Look at this: $ It\'s a LINE emoji!',
        emojis: [
          {
              index: 14,
              productId: '5ac1bfd5040ab15980c9b435',
              emojiId: '001'
          }
        ]
      })
=end

    when 'buttons'
      reply_content(bot_id, event, 
        Button.new(
          'My button sample',
          [
            Action::Uri.new('Go to line-works.com', 'https://line-works.com'),
            # postback is not allowed in button template
            #Action::Postback.new('Send postback', 'hello world'),
            Action::Message.new('Send message', 'This is message')
          ]
        )
      )

=begin
    # CHECKME: confirm is not supported in LINEWORKS, right?
    when 'confirm'
      reply_content(bot_id, event, {
        type: 'template',
        altText: 'Confirm alt text',
        template: {
          type: 'confirm',
          text: 'Do it?',
          actions: [
            { label: 'Yes', type: 'message', text: 'Yes!' },
            { label: 'No', type: 'message', text: 'No!' },
          ],
        }
      })
=end

    when 'carousel'
      reply_content(bot_id, event, 
        Carousel.new(
          'rectangle',
          'cover',
          [
            Carousel::Column.new(
              title: 'hoge',
              text: 'fuga',
              actions: [
                Action::Uri.new('Go to line-works.com', 'https://line-works.com'),
                Action::Postback.new('Send postback', 'hello world'),
                Action::Message.new('Send message', 'This is message')
              ]
            )
            # CHECKME: Datetime picker is not supported in LINE WORKS, right?
          ]
        )
      )

    when 'image carousel'
      reply_content(bot_id, event, 
        Carousel.new(
          'rectangle',
          'cover',
          [
            Carousel::Column.new(
              text: 'Action 1',
              original_content_url: THUMBNAIL_URL,
              actions: [
                Action::Uri.new('Go to line-works.com', 'https://line-works.com')
              ]
            ),
            Carousel::Column.new(
              text: 'Action 2',
              original_content_url: THUMBNAIL_URL,
              actions: [
                Action::Postback.new('Send postback', 'hello world')
              ]
            ),
            Carousel::Column.new(
              text: 'Action 3',
              original_content_url: THUMBNAIL_URL,
              actions: [
                Action::Message.new('Send message', 'This is message')
              ]
            )
            # CHECKME: Datetime picker is not supported in line-works, right?
          ]
        )
      )

=begin
    # CHECKME: imagemap is not supported in LINEWORKS, right?
    when 'imagemap'
      reply_content(bot_id, event, {
        type: 'imagemap',
        baseUrl: THUMBNAIL_URL,
        altText: 'Imagemap alt text',
        baseSize: { width: 1024, height: 1024 },
        actions: [
          { area: { x: 0, y: 0, width: 512, height: 512 }, type: 'uri', linkUri: 'https://store.line.me/family/manga/en' },
          { area: { x: 512, y: 0, width: 512, height: 512 }, type: 'uri', linkUri: 'https://store.line.me/family/music/en' },
          { area: { x: 0, y: 512, width: 512, height: 512 }, type: 'uri', linkUri: 'https://store.line.me/family/play/en' },
          { area: { x: 512, y: 512, width: 512, height: 512 }, type: 'message', text: 'Fortune!' },
        ]
      })
=end

=begin
    # CHECKME: imagemap is not supported in LINEWORKS, right?
    when 'imagemap video'
      video_url = File.join(settings.app_base_url.to_s, 'imagemap/video.mp4')
      preview_url = File.join(settings.app_base_url.to_s, 'imagemap/preview.jpg')
      reply_content(bot_id, event, {
        type: 'imagemap',
        baseUrl: THUMBNAIL_URL,
        altText: 'Imagemap alt text',
        baseSize: { width: 1040, height: 1040 },
        video: {
          originalContentUrl: video_url,
          previewImageUrl: preview_url,
          area: {
            x: 0,
            y: 0,
            width: 520,
            height: 520,
          },
          external_link: {
            linkUri: 'https://line.me',
            label: 'LINE',
          },
        },
        actions: [
          { area: { x: 0, y: 0, width: 512, height: 512 }, type: 'uri', linkUri: 'https://store.line.me/family/manga/en' },
          { area: { x: 512, y: 0, width: 512, height: 512 }, type: 'uri', linkUri: 'https://store.line.me/family/music/en' },
          { area: { x: 0, y: 512, width: 512, height: 512 }, type: 'uri', linkUri: 'https://store.line.me/family/play/en' },
          { area: { x: 512, y: 512, width: 512, height: 512 }, type: 'message', text: 'Fortune!' },
        ]
      })
=end

    when 'flex'
      reply_content(bot_id, event,
        Flex.new(
          'this is a flex message',
          {
            type: "bubble",
            header: {
              type: "box",
              layout: "vertical",
              contents: [
                {
                  type: "text",
                  text: "Header text"
                }
              ]
            },
            hero: {
              type: "image",
              url: HORIZONTAL_THUMBNAIL_URL,
              size: "full",
              aspectRatio: "4:3"
            },
            body: {
              type: "box",
              layout: "vertical",
              contents: [
                {
                  type: "text",
                  text: "Body text",
                }
              ]
            },
            footer: {
              type: "box",
              layout: "vertical",
              contents: [
                {
                  type: "text",
                  text: "Footer text",
                  align: "center",
                  color: "#888888"
                }
              ]
            }
          }
        )
      )

    when 'flex carousel'
      reply_content(bot_id, event,
        Flex.new(
          "this is a flex carousel",
          {
            type: "carousel",
            contents: [
              {
                type: "bubble",
                body: {
                  type: "box",
                  layout: "horizontal",
                  contents: [
                    {
                      type: "text",
                      text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      wrap: true
                    }
                  ]
                },
                footer: {
                  type: "box",
                  layout: "horizontal",
                  contents: [
                    {
                      type: "button",
                      style: "primary",
                      action: {
                        type: "uri",
                        label: "Go",
                        uri: "https://example.com",
                        altUri: {
                          desktop: "https://example.com#desktop"
                        },
                      }
                    }
                  ]
                }
              },
              {
                type: "bubble",
                body: {
                  type: "box",
                  layout: "horizontal",
                  contents: [
                    {
                      type: "text",
                      text: "Hello, World!",
                      wrap: true
                    }
                  ]
                },
                footer: {
                  type: "box",
                  layout: "horizontal",
                  contents: [
                    {
                      type: "button",
                      style: "primary",
                      action: {
                        type: "uri",
                        label: "Go",
                        uri: "https://example.com",
                        altUri: {
                          desktop: "https://example.com#desktop"
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        )
      )

    when 'quickreply'
      reply_content(bot_id, event, 
        Text.new('[QUICK REPLY]') do |t|
          t.quick_reply = QuickReply.new(
              items: [
                QuickReply::Item.new(
                  QUICK_REPLY_ICON_URL,
                  Action::Message.new('Sushi', 'Sushi')
                ),
                QuickReply::Item.new(
                  nil,
                  Action::Location.new('Send location')
                ),
                QuickReply::Item.new(
                  QUICK_REPLY_ICON_URL,
                  Action::Camera.new('Open camera')
                ),
                QuickReply::Item.new(
                  QUICK_REPLY_ICON_URL,
                  Action::CameraRoll.new('Open cameraRoll')
                ),
                QuickReply::Item.new(
                  QUICK_REPLY_ICON_URL,
                  Action::Postback.new('buy', 'action=buy&itemid=111', 'buy')
                ),
                QuickReply::Item.new(
                  QUICK_REPLY_ICON_URL,
                  Action::Message.new('Yes', 'Yes')
                )
              ]
            )
        end
      )

    when 'flex1'
      reply_content(bot_id, event, 
        Flex.new("", 
          {
            "type": "bubble",
            "size": "nano",
            "hero": {
              "type": "image",
              "url": THUMBNAIL_URL,
              "size": "full",
              "aspectRatio": "4:3",
              "action": {
                "type": "uri",
                "uri": "https://line-works.com"
              }
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "hello",
                  "contents": [
                    {
                      "type": "span",
                      "text": "hello",
                      "color": "#FF0000"
                    },
                    {
                      "type": "span",
                      "text": "world",
                      "color": "#0000FF"
                    }
                  ]
                }
              ],
              "paddingAll": "10px"
            },
          }
        ).to_h
      )

    when 'bye'
      case event['source']['type']
      when 'user'
        reply_text(bot_id, event, "[BYE]\nBot can't leave from 1:1 chat")
      when 'group'
        reply_text(bot_id, event, "[BYE]\nLeaving group")
        client.leave_group(event['source']['groupId'])
      when 'room'
        reply_text(bot_id, event, "[BYE]\nLeaving room")
        client.leave_room(event['source']['roomId'])
      end

=begin
    # CHECKME: pending status
    when 'stats'
      response = broadcast({
        type: 'template',
        altText: 'stats',
        template: {
          type: 'buttons',
          thumbnailImageUrl: THUMBNAIL_URL,
          title: 'stats sample',
          text: 'Hello, my stats',
          actions: [
            { label: 'Go to line.me', type: 'uri', uri: 'https://line.me', altUri: {desktop: 'https://line.me#desktop'} },
            { label: 'Send postback', type: 'postback', data: 'hello world' },
            { label: 'Send postback2', type: 'postback', data: 'hello world', text: 'hello world' },
            { label: 'Send message', type: 'message', text: 'This is message' }
          ]
        }
      })
      request_id = response.header["X-Line-Request-Id"]
      reply_text(bot_id, event, "RequestId: #{request_id}")

    when /\Astats\s+(?<request_id>.+)/
      request_id = Regexp.last_match[:request_id]
      stats = client.get_user_interaction_statistics(request_id)
      reply_text(bot_id, event, "[STATS]\n#{stats.body}")
=end

    else
      reply_text(bot_id, event, "[ECHO]\n#{event.message['text']}")

    end
  else
    logger.info "Unknown message type: #{event.type}"
    reply_text(bot_id, event, "[UNKNOWN]\n#{event.type}")
  end
end

def handle_sticker(bot_id, event)
  # Message API available stickers
  # https://developers.line.me/media/messaging-api/sticker_list.pdf
  msgapi_available = event.message['packageId'].to_i <= 4
  messages = [{
    type: 'text',
    text: "[STICKER]\npackageId: #{event.message['packageId']}\nstickerId: #{event.message['stickerId']}"
  }]
  if msgapi_available
    messages.push(
      type: 'sticker',
      packageId: event.message['packageId'],
      stickerId: event.message['stickerId']
    )
  end
  reply_content(bot_id, event, messages)
end

def handle_location(bot_id, event)
  message = event.message
  reply_content(bot_id, event, {
    type: 'location',
    title: message['title'] || message['address'],
    address: message['address'],
    latitude: message['latitude'],
    longitude: message['longitude']
  })
end

=begin
def handle_unsend(bot_id, event)
  source = event['source']
  id = case source['type']
  when 'user'
    source['userId']
  when 'group'
    source['groupId']
  when 'room'
    source['roomId']
  end
  client.push_message(id, {
    type: 'text',
    text: "[UNSEND]\nmessageId: #{event['unsend']['messageId']}"
  })
end
=end
