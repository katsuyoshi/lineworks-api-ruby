require 'spec_helper'
require 'webmock/rspec'
require 'json'

describe Lineworks::Api::Message::Template do
  it 'get the text message' do
    message = 'Hello, world'
    response = Lineworks::Api::Message::Template.text message

    expected = {
      type: 'text',
      text: message
    }
    expect(response).to eq(expected)
  end

  it 'get the stamp message' do
    package_id = 1
    sticker_id = 2
    response = Lineworks::Api::Message::Template.stamp package_id, sticker_id

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
    response = Lineworks::Api::Message::Template.image original_url, preview_url

    expected = {
      type: 'image',
      originalContentUrl: original_url,
      previewImageUrl: preview_url
    }
    expect(response).to eq(expected)
  end

  it 'get the image message with only original url' do
    original_url = 'https://example.com/image.png'
    response = Lineworks::Api::Message::Template.image original_url

    expected = {
      type: 'image',
      previewImageUrl: original_url,
      originalContentUrl: original_url
    }
    expect(response).to eq(expected)
  end

  it 'get the image message with file id' do
    file_id = 'image_id'
    response = Lineworks::Api::Message::Template.image_with_file file_id

    expected = {
      type: 'image',
      fileId: file_id
    }
    expect(response).to eq(expected)
  end

  it 'get the file message with url' do
    file_url = 'https://example.com/file.pdf'
    response = Lineworks::Api::Message::Template.file file_url

    expected = {
      type: 'file',
      originalContentUrl: file_url
    }
    expect(response).to eq(expected)
  end

  it 'get the file message with file id' do
    file_id = 'file_id'
    response = Lineworks::Api::Message::Template.file_with_id file_id

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
    response = Lineworks::Api::Message::Template.link content, link, url

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
      Lineworks::Api::Message::Action.postback('label', 'data')
    ]
    response = Lineworks::Api::Message::Template.button title, actions

    expected = {
      type: 'button_template',
      contentText: title,
      actions: actions
    }
    expect(response).to eq(expected)
  end

  it 'get the list message' do
    header = 'header'
    cover = Lineworks::Api::Message::Template.list_cover(title: 'title', sub_title: 'sub_title', image_url: 'https://example.com/sample.png')
    element_actions = [
      Lineworks::Api::Message::Action.postback('label', 'data')
    ]
    elements = [
      Lineworks::Api::Message::Template.list_element(title: 'title', sub_title: 'sub_title',
                                                     content_url: 'https://example.com/sample.png', actions: element_actions)
    ]
    actions = [
      [
        Lineworks::Api::Message::Action.postback('label', 'data')
      ],
      [
        Lineworks::Api::Message::Action.postback('label', 'data')
      ]
    ]
    response = Lineworks::Api::Message::Template.list(cover, elements, actions)

    expected = {
      type: 'list_template',
      cover: cover,
      elements: elements,
      actions: actions
    }
    expect(response).to eq(expected)
  end

  it 'get the carousel message' do
    action = Lineworks::Api::Message::Action.postback('label', 'data')
    columns = [
      Lineworks::Api::Message::Template.carousel_column(original_content_url: 'https://example.com/sample.png',
                                                        title: 'title', text: 'text', default_action: action, actions: [action])
    ]
    response = Lineworks::Api::Message::Template.carousel('rectangle', 'cover', columns)

    expected = {
      type: 'carousel',
      imageAspectRatio: 'rectangle',
      imageSize: 'cover',
      columns: columns
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

    response = Lineworks::Api::Message::Template.flexible alt_text, contents

    expected = {
      type: 'flex',
      altText: alt_text,
      contents: contents
    }
    expect(response).to eq(expected)
  end
end
