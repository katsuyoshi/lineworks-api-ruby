require 'sinatra'   # gem 'sinatra'
require 'lineworks-api'  # gem 'line-bot-api'
require 'dotenv'        # gem 'dotenv'

Dotenv.load

THUMBNAIL_URL = 'https://via.placeholder.com/1024x1024'
HORIZONTAL_THUMBNAIL_URL = 'https://via.placeholder.com/1024x768'
QUICK_REPLY_ICON_URL = 'https://via.placeholder.com/64x64'

set :app_base_url, ENV['APP_BASE_URL']

def client
  @client ||= Lineworks::Api::Client.new do |config|
    config.channel_secret = ENV['LINE_WORKS_BOT_SECRET']
    config.channel_token = ENV['LINE_WORKS_ACCESS_TOKEN']
    config.http_options = {
      open_timeout: 5,
      read_timeout: 5,
    }
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

def reply_content(event, messages)
  res = client.reply_message(
    event['replyToken'],
    messages
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
  when Lineworks::Api::Event::Message
    handle_message(bot_id, event)

  when Lineworks::Api::Event::Joined
    reply_text(bot_id, event, "[JOINED]\nThank you for joined")

  when Lineworks::Api::Event::Left
    logger.info "[LEFT]\n#{body}"

  when Lineworks::Api::Event::Join
    reply_text(bot_id, event, "[JOIN]\n#{event['source']['type']}")

  when Lineworks::Api::Event::Leave
    logger.info "[LEAVE]\n#{body}"

  when Lineworks::Api::Event::Postback
    message = "[POSTBACK]\n#{event['postback']['data']} (#{JSON.generate(event['postback']['params'])})"
    reply_text(bot_id, event, message)

=begin
  when Lineworks::Api::Event::Beacon
    reply_text(bot_id, event, "[BEACON]\n#{JSON.generate(event['beacon'])}")

  when Lineworks::Api::Event::Things
    reply_text(bot_id, event, "[THINGS]\n#{JSON.generate(event['things'])}")

  when Lineworks::Api::Event::VideoPlayComplete
    reply_text(bot_id, event, "[VIDEOPLAYCOMPLETE]\n#{JSON.generate(event['videoPlayComplete'])}")

  when Lineworks::Api::Event::Unsend
    handle_unsend(bot_id, event)
=end

  else
    reply_text(bot_id, event, "Unknown event type: #{event}")
  end

  "OK"
end

def handle_message(bot_id, event)
  case event.type
  when Lineworks::Api::Event::MessageType::Image
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body)
    reply_text(bot_id, event, "[MessageType::IMAGE]\nid:#{message_id}\nreceived #{tf.size} bytes data")
=begin
  when Lineworks::Api::Event::MessageType::Video
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body)
    reply_text(bot_id, event, "[MessageType::VIDEO]\nid:#{message_id}\nreceived #{tf.size} bytes data")
  when Lineworks::Api::Event::MessageType::Audio
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body)
    reply_text(bot_id, event, "[MessageType::AUDIO]\nid:#{message_id}\nreceived #{tf.size} bytes data")
=end
  when Lineworks::Api::Event::MessageType::File
    message_id = event.message['id']
    response = client.get_message_content(message_id)
    tf = Tempfile.open("content")
    tf.write(response.body)
    reply_text(bot_id, event, "[MessageType::FILE]\nid:#{message_id}\nfileName:#{event.message['fileName']}\nfileSize:#{event.message['fileSize']}\nreceived #{tf.size} bytes data")
  when Lineworks::Api::Event::MessageType::Sticker
    handle_sticker(event)
  when Lineworks::Api::Event::MessageType::Location
    handle_location(event)
  when Lineworks::Api::Event::MessageType::Text
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

    when 'emoji'
      reply_content(event, {
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

    when 'buttons'
      reply_content(event, {
        type: 'template',
        altText: 'Buttons alt text',
        template: {
          type: 'buttons',
          thumbnailImageUrl: THUMBNAIL_URL,
          title: 'My button sample',
          text: 'Hello, my button',
          actions: [
            { label: 'Go to line.me', type: 'uri', uri: 'https://line.me', altUri: {desktop: 'https://line.me#desktop'} },
            { label: 'Send postback', type: 'postback', data: 'hello world' },
            { label: 'Send postback2', type: 'postback', data: 'hello world', text: 'hello world' },
            { label: 'Send message', type: 'message', text: 'This is message' }
          ]
        }
      })

    when 'confirm'
      reply_content(event, {
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

    when 'carousel'
      reply_content(event, {
        type: 'template',
        altText: 'Carousel alt text',
        template: {
          type: 'carousel',
          columns: [
            {
              title: 'hoge',
              text: 'fuga',
              actions: [
                { label: 'Go to line.me', type: 'uri', uri: 'https://line.me', altUri: {desktop: 'https://line.me#desktop'} },
                { label: 'Send postback', type: 'postback', data: 'hello world' },
                { label: 'Send message', type: 'message', text: 'This is message' }
              ]
            },
            {
              title: 'Datetime Picker',
              text: 'Please select a date, time or datetime',
              actions: [
                {
                  type: 'datetimepicker',
                  label: "Datetime",
                  data: 'action=sel',
                  mode: 'datetime',
                  initial: '2017-06-18T06:15',
                  max: '2100-12-31T23:59',
                  min: '1900-01-01T00:00'
                },
                {
                  type: 'datetimepicker',
                  label: "Date",
                  data: 'action=sel&only=date',
                  mode: 'date',
                  initial: '2017-06-18',
                  max: '2100-12-31',
                  min: '1900-01-01'
                },
                {
                  type: 'datetimepicker',
                  label: "Time",
                  data: 'action=sel&only=time',
                  mode: 'time',
                  initial: '12:15',
                  max: '23:00',
                  min: '10:00'
                }
              ]
            }
          ]
        }
      })

    when 'image carousel'
      reply_content(event, {
        type: 'template',
        altText: 'Image carousel alt text',
        template: {
          type: 'image_carousel',
          columns: [
            {
              imageUrl: THUMBNAIL_URL,
              action: { label: 'line.me', type: 'uri', uri: 'https://line.me', altUri: {desktop: 'https://line.me#desktop'} }
            },
            {
              imageUrl: THUMBNAIL_URL,
              action: { label: 'postback', type: 'postback', data: 'hello world' }
            },
            {
              imageUrl: THUMBNAIL_URL,
              action: { label: 'message', type: 'message', text: 'This is message' }
            },
            {
              imageUrl: THUMBNAIL_URL,
              action: {
                type: 'datetimepicker',
                label: "Datetime",
                data: 'action=sel',
                mode: 'datetime',
                initial: '2017-06-18T06:15',
                max: '2100-12-31T23:59',
                min: '1900-01-01T00:00'
              }
            }
          ]
        }
      })

    when 'imagemap'
      reply_content(event, {
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

    when 'imagemap video'
      video_url = File.join(settings.app_base_url.to_s, 'imagemap/video.mp4')
      preview_url = File.join(settings.app_base_url.to_s, 'imagemap/preview.jpg')
      reply_content(event, {
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

    when 'flex'
      reply_content(event, {
        type: "flex",
        altText: "this is a flex message",
        contents: {
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
      })

    when 'flex carousel'
      reply_content(event, {
        type: "flex",
        altText: "this is a flex carousel",
        contents: {
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
      })

    when 'quickreply'
      reply_content(event, {
        type: 'text',
        text: '[QUICK REPLY]',
        quickReply: {
          items: [
            {
              type: "action",
              imageUrl: QUICK_REPLY_ICON_URL,
              action: {
                type: "message",
                label: "Sushi",
                text: "Sushi"
              }
            },
            {
              type: "action",
              action: {
                type: "location",
                label: "Send location"
              }
            },
            {
              type: "action",
              imageUrl: QUICK_REPLY_ICON_URL,
              action: {
                type: "camera",
                label: "Open camera",
              }
            },
            {
              type: "action",
              imageUrl: QUICK_REPLY_ICON_URL,
              action: {
                type: "cameraRoll",
                label: "Open cameraRoll",
              }
            },
            {
              type: "action",
              action: {
                type: "postback",
                label: "buy",
                data: "action=buy&itemid=111",
                text: "buy",
              }
            },
            {
              type: "action",
              action: {
                type: "message",
                label: "Yes",
                text: "Yes"
              }
            },
            {
              type: "action",
              action: {
                type: "datetimepicker",
                label: "Select date",
                data: "storeId=12345",
                mode: "datetime",
                initial: "2017-12-25t00:00",
                max: "2018-01-24t23:59",
                min: "2017-12-25t00:00"
              }
            },
          ],
        },
      })

    when 'flex1'
      reply_content(event, {
        "type": "bubble",
        "size": "nano",
        "hero": {
          "type": "image",
          "url": THUMBNAIL_URL,
          "size": "full",
          "aspectRatio": "4:3",
          "action": {
            "type": "uri",
            "uri": "http://linecorp.com/"
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
      })

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
  reply_content(event, messages)
end

def handle_location(event)
  message = event.message
  reply_content(event, {
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
