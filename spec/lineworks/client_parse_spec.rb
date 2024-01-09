require 'spec_helper'


TEXT_MESSAGE_EVENT_CONTENT = <<"EOS"
{
  "type": "message",
  "source": {
    "userId": "c72af563-0f21-4736-11e4-045237113344",
    "channelId": "12345a12-b12c-12d3-e123fghijkl",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "content": {
    "type": "text",
    "text": "hello"
  }
}
EOS

LOCATION_MESSAGE_EVENT_CONTENT = <<"EOS"
{
  "type": "message",
  "source": {
    "userId": "c72af563-0f21-4736-11e4-045237113344",
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "content": {
    "type": "location",
    "address": "〒150-0002 東京都渋谷区渋谷２丁目１５−１",
    "latitude": 35.6587750,
    "longitude": 139.7052230
  }
}
EOS

STICKER_MESSAGE_EVENT_CONTENT = <<"EOS"
{
  "type": "message",
  "source": {
    "userId": "c72af563-0f21-4736-11e4-045237113344",
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "content": {
    "type": "sticker",
    "packageId": "1",
    "stickerId": "1"
  }
}
EOS

IMAGE_MESSAGE_EVENT_CONTENT = <<"EOS"
{
  "type": "message",
  "source": {
    "userId": "c72af563-0f21-4736-11e4-045237113344",
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "content": {
    "type": "image",
    "fileId": "WAAAQPwBexX2HnseNvvM9Zyhvp2kIRF3Ul7L7/aMVti8="
  }
}
EOS

FILE_MESSAGE_EVENT_CONTENT = <<"EOS"
{
  "type": "message",
  "source": {
    "userId": "c72af563-0f21-4736-11e4-045237113344",
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "content": {
    "type": "file",
    "fileId": "WAAAQPwBexX2HnseNvvM9Zyhvp2kIRF3Ul7L7/aMVti8="
  }
}
EOS

POSTBACK_EVENT_CONTENT = <<"EOS"
{
  "type": "postback",
  "source": {
    "userId": "c72af563-0f21-4736-11e4-045237113344",
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "data": "action=buy"
}
EOS

JOIN_EVENT_CONTENT = <<"EOS"
{
  "type": "join",
  "source": {
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime":"2022-01-04T05:16:05Z"
}
EOS

LEAVE_EVENT_CONTENT = <<"EOS"
{
  "type": "leave",
  "source": {
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z"
}
EOS

JOINED_EVENT_CONTENT = <<"EOS"
{
  "type": "joined",
  "source": {
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "members":["userf7da-f82c-4284-13e7-030f3b4c756x"]
}
EOS

LEFT_EVENT_CONTENT = <<"EOS"
{
  "type": "left",
  "source": {
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "members":["userf7da-f82c-4284-13e7-030f3b4c756x"]
}
EOS

UNKNOWN_EVENT_CONTENT = <<"EOS"
{
  "type": "unknown",
  "source": {
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z"
}
EOS

UNSUPPORT_MESSAGE_EVENT_CONTENT = <<"EOS"
{
  "type": "message",
  "source": {
    "channelId": "12345",
    "domainId": 40029600
  },
  "issuedTime": "2022-01-04T05:16:05.716Z",
  "content": {
    "id": "contentid"
  }
}
EOS



describe Lineworks::Bot::Client do
  def dummy_config
    {
      channel_token: 'access token',
    }
  end

  def generate_client
    client = Lineworks::Bot::Client.new do |config|
      config.channel_token = dummy_config[:channel_token]
    end

    client
  end

  it 'parses text message event' do
    client = generate_client
    event = client.parse_event_from(TEXT_MESSAGE_EVENT_CONTENT)

    message = {
      'type' => "text",
      'text' => "hello"
    }
    expect(event).to be_a(Lineworks::Bot::Event::Message)
    expect(event.type).to eq(Lineworks::Bot::Event::MessageType::Text)
    expect(event.message).to eq message

  end

  it 'parses location message event' do
    client = generate_client
    event = client.parse_event_from(LOCATION_MESSAGE_EVENT_CONTENT)

    message = {
      "type" => "location",
      "address" => "〒150-0002 東京都渋谷区渋谷２丁目１５−１",
      "latitude" => 35.6587750,
      "longitude" => 139.7052230
    }
    expect(event).to be_a(Lineworks::Bot::Event::Message)
    expect(event.type).to eq(Lineworks::Bot::Event::MessageType::Location)
    expect(event.message).to eq message

  end

  it 'parses sticker message event' do
    client = generate_client
    event = client.parse_event_from(STICKER_MESSAGE_EVENT_CONTENT)

    message = {
      "type" => "sticker",
      "packageId" => "1",
      "stickerId" => "1"
    }
    expect(event).to be_a(Lineworks::Bot::Event::Message)
    expect(event.type).to eq(Lineworks::Bot::Event::MessageType::Sticker)
    expect(event.message).to eq message

  end

  it 'parses image message event' do
    client = generate_client
    event = client.parse_event_from(IMAGE_MESSAGE_EVENT_CONTENT)

    message = {
      "type" => "image",
      "fileId" => "WAAAQPwBexX2HnseNvvM9Zyhvp2kIRF3Ul7L7/aMVti8="
    }
    expect(event).to be_a(Lineworks::Bot::Event::Message)
    expect(event.type).to eq(Lineworks::Bot::Event::MessageType::Image)
    expect(event.message).to eq message
  end

  it 'parses file message event' do
    client = generate_client
    event = client.parse_event_from(FILE_MESSAGE_EVENT_CONTENT)

    message = {
      "type" => "file",
      "fileId" => "WAAAQPwBexX2HnseNvvM9Zyhvp2kIRF3Ul7L7/aMVti8="
    }
    expect(event).to be_a(Lineworks::Bot::Event::Message)
    expect(event.type).to eq(Lineworks::Bot::Event::MessageType::File)
    expect(event.message).to eq message
  end

  it 'parses postback event' do
    client = generate_client
    event = client.parse_event_from(POSTBACK_EVENT_CONTENT)

    expect(event).to be_a(Lineworks::Bot::Event::Postback)
    expect(event.data).to eq('action=buy')
  end

  it 'parses join event' do
    client = generate_client
    event = client.parse_event_from(JOIN_EVENT_CONTENT)

    expect(event).to be_a(Lineworks::Bot::Event::Join)
    expect(event.channel_id).to eq('12345')
    expect(event.domain_id).to eq(40029600)
    expect(event.issued_at).to eq(Time.iso8601('2022-01-04T05:16:05Z'))
  end

  it 'parses leave event' do
    client = generate_client
    event = client.parse_event_from(LEAVE_EVENT_CONTENT)

    expect(event).to be_a(Lineworks::Bot::Event::Leave)
    expect(event.channel_id).to eq('12345')
    expect(event.domain_id).to eq(40029600)
    expect(event.issued_at).to eq(Time.iso8601('2022-01-04T05:16:05.716Z'))
  end

  it 'parses joined event' do
    client = generate_client
    event = client.parse_event_from(JOINED_EVENT_CONTENT)

    expect(event).to be_a(Lineworks::Bot::Event::Joined)
    expect(event.channel_id).to eq('12345')
    expect(event.domain_id).to eq(40029600)
    expect(event.issued_at).to eq(Time.iso8601('2022-01-04T05:16:05.716Z'))
    expect(event.members).to eq(["userf7da-f82c-4284-13e7-030f3b4c756x"])
  end

  it 'parses left event' do
    client = generate_client
    event = client.parse_event_from(LEFT_EVENT_CONTENT)

    expect(event).to be_a(Lineworks::Bot::Event::Left)
    expect(event.channel_id).to eq('12345')
    expect(event.domain_id).to eq(40029600)
    expect(event.issued_at).to eq(Time.iso8601('2022-01-04T05:16:05.716Z'))
    expect(event.members).to eq(["userf7da-f82c-4284-13e7-030f3b4c756x"])
  end

  it 'parses unknown event' do
    client = generate_client
    event = client.parse_event_from(UNKNOWN_EVENT_CONTENT)

    expect(event).to be_a(Lineworks::Bot::Event::Base)
  end

  it 'parses unsupport message event' do
    client = generate_client
    event = client.parse_event_from(UNSUPPORT_MESSAGE_EVENT_CONTENT)

    expect(event).to be_a(Lineworks::Bot::Event::Message)
    expect(event.type).to eq(Lineworks::Bot::Event::MessageType::Unsupport)
  end


end
