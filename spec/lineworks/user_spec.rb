require 'spec_helper'
require 'webmock/rspec'
require 'json'

include Lineworks::Directory

describe User do
  before(:all) do
    @user = User.new userExternalKey: 'userExternalKey', email: 'email', userName: { lastName: 'lastName', firstName: 'firstName' }, phoneticLastName: 'phoneticLastName', phoneticFirstName: 'phoneticFirstName', nickName: 'nickName', privateEmail: 'privateEmail', aliasEmails: ['aliasEmails'], employmentTypeId: 'employmentTypeId', userTypeId: 'userTypeId', searchable: true, organizations: [{ domainId: 'domainId', primary: true, userExternalKey: 'userExternalKey', email: 'email', levelId: 'levelId', executive: true, orgUnits: [{:orgUnitId=>"orgunitf-f27f-4af8-27e1-03817a911417", :orgUnitExternalKey=>nil, :orgUnitEmail=>"team01@example.com", :orgUnitName=>"組織01", :primary=>true, :positionId=>"position-7027-4a02-b838-6f52b5e38db7",    :positionExternalKey=>nil, :positionName=>"社員", :isManager=>true, :visible=>true, :useTeamFeature=>true}], organizationName: 'organizationName', levelExternalKey: 'levelExternalKey', levelName: 'levelName' }], telephone: 'telephone', cellPhone: 'cellPhone', location: 'location', task: 'task', messenger: { protocol: "LINE",
    messengerId: "lineid"
}, birthdayCalendarType: 'birthdayCalendarType', birthday: 'birthday', hiredDate: 'hiredDate', locale: 'locale', timeZone: 'timeZone', customFields: [{ customFieldId: "customfd-fc09-4a57-ab38-03dc6c425e09",
  value: "カスタム値",
  link: nil }], relations: [{ relationUserId: "userfd-fc09-4a57-ab38-03dc6c425e09", relationName: "Manager",  externalKey: "ExternalKeyValue" }], employeeNumber: 'employeeNumber', activationDate: 'activationDate', isAdministrator: true, isAwaiting: false, isPending: nil, isSuspended: true, leaveOfAbsence: { startTime: 'startTime', endTime: 'endTime', isLeaveOfAbsence: true }, isDeleted: true, suspendedReason: 'suspendedReason', employmentTypeExternalKey: 'employmentTypeExternalKey', employmentTypeName: 'employmentTypeName', userTypeExternalKey: 'userTypeExternalKey', userTypeName: 'userTypeName', userTypeCode: 'userTypeCode', userId: 'userId'
  end

  it 'has user_name' do
    expect(@user.user_name).to be_a(UserName)
  end

  it 'has organizations' do
    expect(@user.organizations.size).to be(1)
    expect(@user.organizations.first).to be_a(UserOrganization)
    o = @user.organizations.first
    expect(o.org_units.size).to be(1)
    expect(o.org_units.first).to be_a(OrgUnit)
  end


  it 'has messenger' do
    expect(@user.messenger).to be_a(Messenger)
  end

  it 'has custom_fields' do
    expect(@user.custom_fields.size).to be(1)
    expect(@user.custom_fields.first).to be_a(UserCustomField)
  end

  it 'has relations' do
    expect(@user.relations.size).to be(1)
    expect(@user.relations.first).to be_a(UserRelation)
  end

  it 'should be administrator? true' do
    expect(@user.administrator?).to be_truthy
  end

  it 'should be awaiting? false' do
    expect(@user.awaiting?).to be_falsey
  end

  it 'shoudld be pending? false' do
    expect(@user.pending?).to be_falsey
  end

end
