require 'spec_helper'
require 'webmock/rspec'
require 'json'

include Lineworks::Directory

describe User do
  before(:all) do
    @user = User.new userExternalKey: 'userExternalKey', email: 'email', userName: { lastName: 'lastName', firstName: 'firstName' }, phoneticLastName: 'phoneticLastName', phoneticFirstName: 'phoneticFirstName', nickName: 'nickName', privateEmail: 'privateEmail', aliasEmails: ['aliasEmails'], employmentTypeId: 'employmentTypeId', userTypeId: 'userTypeId', searchable: true, organizations: [{ domainId: 'domainId', primary: true, userExternalKey: 'userExternalKey', email: 'email', levelId: 'levelId', executive: true, orgUnits: ['orgUnits'], organizationName: 'organizationName', levelExternalKey: 'levelExternalKey', levelName: 'levelName' }], telephone: 'telephone', cellPhone: 'cellPhone', location: 'location', task: 'task', messenger: 'messenger', birthdayCalendarType: 'birthdayCalendarType', birthday: 'birthday', hiredDate: 'hiredDate', locale: 'locale', timeZone: 'timeZone', customFields: ['customFields'], relations: ['relations'], employeeNumber: 'employeeNumber', activationDate: 'activationDate', isAdministrator: true, isAwaiting: false, isPending: nil, isSuspended: true, leaveOfAbsence: { startTime: 'startTime', endTime: 'endTime', isLeaveOfAbsence: true }, isDeleted: true, suspendedReason: 'suspendedReason', employmentTypeExternalKey: 'employmentTypeExternalKey', employmentTypeName: 'employmentTypeName', userTypeExternalKey: 'userTypeExternalKey', userTypeName: 'userTypeName', userTypeCode: 'userTypeCode', userId: 'userId'
  end

  it 'has user name' do
    expect(@user.user_name).to be_a(UserName)
  end

  it 'has organization' do
    expect(@user.organizations.size).to be(1)
    expect(@user.organizations.first).to be_a(Organization)
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
