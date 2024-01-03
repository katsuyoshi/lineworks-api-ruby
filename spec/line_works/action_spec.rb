require 'spec_helper'
require 'webmock/rspec'
require 'json'

describe Lineworks::Api::Message::Action do
  it 'get the postback action' do
    label = 'label'
    data = 'data'
    text = 'text'
    response = Lineworks::Api::Message::Action.postback label, data, text

    expected = {
      type: 'postback',
      label: label,
      data: data,
      displayText: text
    }
    expect(response).to eq(expected)
  end

  it 'get the message action' do
    label = 'label'
    text = 'text'
    postback = 'postback'
    response = Lineworks::Api::Message::Action.message label, text, postback

    expected = {
      type: 'message',
      label: label,
      text: text,
      postback: postback
    }
    expect(response).to eq(expected)
  end

  it 'get the uri action' do
    label = 'label'
    uri = 'uri'
    response = Lineworks::Api::Message::Action.uri label, uri

    expected = {
      type: 'uri',
      label: label,
      uri: uri
    }
    expect(response).to eq(expected)
  end

  it 'get the camera action' do
    label = 'label'
    response = Lineworks::Api::Message::Action.camera label

    expected = {
      type: 'camera',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the camera roll action' do
    label = 'label'
    response = Lineworks::Api::Message::Action.camera_roll label

    expected = {
      type: 'cameraRoll',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the location action' do
    label = 'label'
    response = Lineworks::Api::Message::Action.location label

    expected = {
      type: 'location',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the copy action' do
    label = 'label'
    copy = 'copy'
    response = Lineworks::Api::Message::Action.copy label, copy

    expected = {
      type: 'copy',
      label: label,
      copyText: copy
    }
    expect(response).to eq(expected)
  end
end
