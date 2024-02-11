require 'spec_helper'


PROFILE_CONTENT = <<"EOS"
{
  "userId": "userf7da-f82c-4284-13e7-030f3b4c756x",
  "email": "localpart@example.com",
  "telephone": "03-1234-5678",
  "cellPhone": "090-1234-5678",
  "location": "green building",
  "userName": {
    "lastName": "ワークス",
    "firstName": "太郎",
    "phoneticLastName": null,
    "phoneticFirstName": null
  },
  "i18nName": [],
  "organizations": [
    {
      "domainId": 10000001,
      "primary": true,
      "userExternalKey": null,
      "email": "localpart@example.com",
      "levelId": "levelaa7-b824-4937-66af-042f1f43cefa",
      "levelExternalKey": null,
      "levelName": "一般社員",
      "executive": false,
      "organizationName": "org",
      "orgUnits": [
        {
          "orgUnitId": "orgunitf-f27f-4af8-27e1-03817a911417",
          "orgUnitExternalKey": null,
          "orgUnitEmail": "team01@example.com",
          "orgUnitName": "組織",
          "primary": true,
          "positionId": "position-7027-4a02-b838-6f52b5e38db7",
          "positionExternalKey": null,
          "positionName": "社員",
          "isManager": true,
          "visible": true,
          "useTeamFeature": true
        }
      ]
    }
  ]
}
EOS


describe Lineworks::Client do
  def dummy_config
    {
      channel_token: 'access token',
    }
  end

  def generate_client
    client = Lineworks::Client.new do |config|
      config.channel_token = dummy_config[:channel_token]
    end

    client
  end

=begin
  it 'gets profile' do
    uri_template = Addressable::Template.new Lineworks::DEFAULT_ENDPOINT + '/users/{user_id}'
    stub_request(:get, uri_template).to_return { |request| {body: PROFILE_CONTENT, status: 200} }

    client = generate_client

    contact = client.get_profile_content("1234567")

    expect(contact[:userId]).to eq "userf7da-f82c-4284-13e7-030f3b4c756x"
    expect(contact[:userName][:lastName]).to eq "ワークス"
    expect(contact[:organizations][0][:orgUnits][0][:orgUnitName]).to eq "組織"
  end
=end

end
