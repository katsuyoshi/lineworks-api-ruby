require 'spec_helper'
require 'webmock/rspec'
require 'json'

include Lineworks::Bot::Message

describe Lineworks::Bot::Message::Action do
  it 'get the postback action' do
    label = 'label'
    data = 'data'
    text = 'text'
    response = Action::Postback.new(label, data, text).to_h

    expected = {
      type: 'postback',
      label: label,
      data: data,
      displayText: text
    }
    expect(response).to eq(expected)
  end

  it 'get the postback action with keyword args' do
    label = 'label'
    data = 'data'
    text = 'text'
    response = Action::Postback.new(label: label, data: data, text: text).to_h

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
    response = Action::Message.new(label, text, postback).to_h

    expected = {
      type: 'message',
      label: label,
      text: text,
      postback: postback
    }
    expect(response).to eq(expected)
  end

  it 'get the message action with keyword args' do
    label = 'label'
    text = 'text'
    postback = 'postback'
    response = Action::Message.new(label: label, text: text, data: postback).to_h

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
    response = Action::Uri.new(label, uri).to_h

    expected = {
      type: 'uri',
      label: label,
      uri: uri
    }
    expect(response).to eq(expected)
  end

  it 'get the uri action with keyword args' do
    label = 'label'
    uri = 'uri'
    response = Action::Uri.new(label: label, uri: uri).to_h

    expected = {
      type: 'uri',
      label: label,
      uri: uri
    }
    expect(response).to eq(expected)
  end

  it 'get the camera action' do
    label = 'label'
    response = Action::Camera.new(label).to_h

    expected = {
      type: 'camera',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the camera action with keyword args' do
    label = 'label'
    response = Action::Camera.new(label: label).to_h

    expected = {
      type: 'camera',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the camera roll action' do
    label = 'label'
    response = Action::CameraRoll.new(label).to_h

    expected = {
      type: 'cameraRoll',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the camera roll action with keyword args' do
    label = 'label'
    response = Action::CameraRoll.new(label: label).to_h

    expected = {
      type: 'cameraRoll',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the location action' do
    label = 'label'
    response = Action::Location.new(label).to_h

    expected = {
      type: 'location',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the location action with keywod args' do
    label = 'label'
    response = Action::Location.new(label: label).to_h

    expected = {
      type: 'location',
      label: label
    }
    expect(response).to eq(expected)
  end

  it 'get the copy action' do
    label = 'label'
    copy = 'copy'
    response = Action::Copy.new(label, copy).to_h

    expected = {
      type: 'copy',
      label: label,
      copyText: copy
    }
    expect(response).to eq(expected)
  end

  it 'get the copy action with keyword args' do
    label = 'label'
    copy = 'copy'
    response = Action::Copy.new(label: label, copy: copy).to_h

    expected = {
      type: 'copy',
      label: label,
      copyText: copy
    }
    expect(response).to eq(expected)
  end
end
