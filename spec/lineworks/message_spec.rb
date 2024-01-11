require 'spec_helper'
require 'webmock/rspec'
require 'json'

include Lineworks::Bot
include Lineworks::Bot::Message

describe Lineworks::Bot::Message do
  it 'get the text message' do
    message = 'Hello, world'

    response = Text.new(message).to_h

    expected = {
      type: 'text',
      text: message
    }
    expect(response).to eq(expected)
  end


  it 'get the text message by keyword arg' do
    message = 'Hello, world'

    response = Text.new(message: message).to_h

    expected = {
      type: 'text',
      text: message
    }
    expect(response).to eq(expected)
  end

  it 'get the stamp message' do
    package_id = 1
    sticker_id = 2

    response = Stamp.new(package_id, sticker_id).to_h

    expected = {
      type: 'sticker',
      packageId: '1',
      stickerId: '2'
    }
    expect(response).to eq(expected)
  end

  it 'get the stamp message by keyword arg' do
    package_id = 1
    sticker_id = 2

    response = Stamp.new(package_id: package_id, sticker_id: sticker_id).to_h

    expected = {
      type: 'sticker',
      packageId: '1',
      stickerId: '2'
    }
    expect(response).to eq(expected)
  end

  it 'get the image message with urls' do
    preview_url = 'https://example.com/image_preview.png'
    original_url = 'https://example.com/image.png'

    response = Image.new(original_url, preview_url).to_h

    expected = {
      type: 'image',
      originalContentUrl: original_url,
      previewImageUrl: preview_url
    }
    expect(response).to eq(expected)
  end

  it 'get the image message with urls by keyword arg' do
    preview_url = 'https://example.com/image_preview.png'
    original_url = 'https://example.com/image.png'

    response = Image.new(original_url: original_url, preview_url: preview_url).to_h

    expected = {
      type: 'image',
      originalContentUrl: original_url,
      previewImageUrl: preview_url
    }
    expect(response).to eq(expected)
  end

  it 'get the image message with only original url by keyword arg' do
    original_url = 'https://example.com/image.png'

    response = Image.new(original_url: original_url).to_h

    expected = {
      type: 'image',
      previewImageUrl: original_url,
      originalContentUrl: original_url
    }
    expect(response).to eq(expected)
  end

  it 'get the image message with file id by keyword arg' do
    file_id = 'image_id'
    
    response = Image.new(file_id: file_id).to_h

    expected = {
      type: 'image',
      fileId: file_id
    }
    expect(response).to eq(expected)
  end

  it 'get the file message with url' do
    file_url = 'https://example.com/file.pdf'

    response = Message::File.new(nil, file_url).to_h

    expected = {
      type: 'file',
      fileId: file_url
    }
    expect(response).to eq(expected)
  end

  it 'get the file message with file id by keyword arg' do
    file_id = 'file_id'

    response = Message::File.new(file_id: file_id).to_h

    expected = {
      type: 'file',
      fileId: file_id
    }
    expect(response).to eq(expected)
  end

  it 'get the link message' do
    content = 'content'
    link = 'link'
    url = 'https://example.com'

    response = Link.new(content, link, url).to_h

    expected = {
      type: 'link',
      contentText: content,
      linkText: link,
      link: url
    }
    expect(response).to eq(expected)
  end

  it 'get the link message by keyword arg' do
    content = 'content'
    link = 'link'
    url = 'https://example.com'

    response = Link.new(content_text: content, link_text: link, url: url).to_h

    expected = {
      type: 'link',
      contentText: content,
      linkText: link,
      link: url
    }
    expect(response).to eq(expected)
  end

  it 'get the button message' do
    title = 'title'
    actions = [
      Action::Postback.new('label', 'data')
    ]

    response = Button.new(title, actions).to_h

    expected = {
      type: 'button_template',
      contentText: title,
      actions: actions
    }
    expect(response).to eq(expected)
  end

  it 'get the button message by keyword arg' do
    title = 'title'
    actions = [
      Action::Postback.new('label', 'data')
    ]

    response = Button.new(title: title, actions: actions).to_h

    expected = {
      type: 'button_template',
      contentText: title,
      actions: actions
    }
    expect(response).to eq(expected)
  end

  it 'get the list message' do
    header = 'header'
    cover = List::Cover.new(title: 'title',
      sub_title: 'sub_title',
      image_url: 'https://example.com/sample.png'
    )
    element_actions = [
      Action::Postback.new('label', 'data')
    ]
    elements = [
      List::Element.new('title',
        sub_title: 'sub_title',
        content_url: 'https://example.com/sample.png', actions: element_actions
      )
    ]
    actions = [
      [
        Action::Postback.new('label', 'data')
      ],
      [
        Action::Postback.new('label', 'data')
      ]
    ]

    response = List.new(cover, elements, actions).to_h

    expected = {
      type: 'list_template',
      cover: cover.to_h,
      elements: elements.map(&:to_h),
      actions: actions.map{ _1.map(&:to_h) }
    }
    expect(response).to eq(expected)
  end

  it 'get the list message by keyword arg' do
    header = 'header'
    cover = List::Cover.new(title: 'title',
      sub_title: 'sub_title',
      image_url: 'https://example.com/sample.png'
    )
    element_actions = [
      Action::Postback.new('label', 'data')
    ]
    elements = [
      List::Element.new(title: 'title',
        sub_title: 'sub_title',
        content_url: 'https://example.com/sample.png', actions: element_actions
      )
    ]
    actions = [
      [
        Action::Postback.new('label', 'data')
      ],
      [
        Action::Postback.new('label', 'data')
      ]
    ]

    response = List.new(cover: cover, elements: elements, actions: actions).to_h

    expected = {
      type: 'list_template',
      cover: cover.to_h,
      elements: elements.map(&:to_h),
      actions: actions.map{ _1.map(&:to_h) }
    }
    expect(response).to eq(expected)
  end

  it 'get the carousel message' do
    action = Action::Postback.new('label', 'data')
    columns = [
      Carousel::Column.new(
        'https://example.com/sample.png',
        nil,
        'title',
        'text',
        action,
        actions: [action]
      )
    ]

    response = Carousel.new('rectangle', 'cover', columns).to_h

    expected = {
      type: 'carousel',
      imageAspectRatio: 'rectangle',
      imageSize: 'cover',
      columns: columns.map(&:to_h)
    }
    expect(response).to eq(expected)
  end

  it 'get the carousel message by keyword arg' do
    action = Action::Postback.new('label', 'data')
    columns = [
      Carousel::Column.new(
        original_content_url: 'https://example.com/sample.png',
        title: 'title',
        text: 'text',
        default_action: action,
        actions: [action]
      )
    ]

    response = Carousel.new(image_aspect_ratio: 'rectangle', image_size: 'cover', columns: columns).to_h

    expected = {
      type: 'carousel',
      imageAspectRatio: 'rectangle',
      imageSize: 'cover',
      columns: columns.map(&:to_h)
    }
    expect(response).to eq(expected)
  end

  it 'get the flexible message' do
    alt_text = 'alt_text'
    contents = {
      "type": 'bubble',
      "body": {
        "type": 'box',
        "layout": 'vertical',
        "contents": [
          {
            "type": 'text',
            "text": 'hello'
          },
          {
            "type": 'text',
            "text": 'world'
          }
        ]
      }
    }

    response = Flex.new(alt_text, contents).to_h

    expected = {
      type: 'flex',
      altText: alt_text,
      contents: contents
    }
    expect(response).to eq(expected)
  end

  it 'get the flexible message by keyword arg' do
    alt_text = 'alt_text'
    contents = {
      "type": 'bubble',
      "body": {
        "type": 'box',
        "layout": 'vertical',
        "contents": [
          {
            "type": 'text',
            "text": 'hello'
          },
          {
            "type": 'text',
            "text": 'world'
          }
        ]
      }
    }

    response = Flex.new(alt_text: alt_text, contents: contents).to_h

    expected = {
      type: 'flex',
      altText: alt_text,
      contents: contents
    }
    expect(response).to eq(expected)
  end

  it 'get the quick reply' do
    image_url = 'https://example.com/image_preview.png'
    action = Action::Postback.new('label', 'data')
    item = QuickReply::Item.new(image_url, action)

    response = QuickReply.new(
      'text',
      [item]
    ).to_h

    expected = {
      text: 'text',
      items: [item.to_h]
    }
    expect(response.to_h).to eq(expected)
  end

  it 'get the quick reply by keyword arg' do
    image_url = 'https://example.com/image_preview.png'
    action = Action::Postback.new('label', 'data')
    item = QuickReply::Item.new( image_url: image_url, action: action)

    response = QuickReply.new(
      text: 'text',
      items: [item]
    ).to_h

    expected = {
      text: 'text',
      items: [item.to_h]
    }
    expect(response.to_h).to eq(expected)
  end

end
