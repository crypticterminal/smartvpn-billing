require 'spec_helper'

describe 'User sign up:' do
  before do
    create(:plan)
  end

  describe 'sign_in page' do
    it 'has sign_up link' do
      visit('/users/sign_in')
      expect(page).to have_content I18n.t('main.auth.sign_up')
    end
  end

  it 'successful scenary' do
    ## Sign up page form filling
    visit('/users/sign_up')
    within('#new_user') do
      fill_in 'user_email', with: 'user@email.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      check 'user_accept_agreement'
    end
    click_button I18n.t('users.registrations.new.sign_up')
    expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')

    ## Registration email confirmation
    token_name = 'confirmation_token'
    token_value = extract_token_from_email(token_name)
    visit("/users/confirmation?#{token_name}=#{token_value}")
    expect(page).to have_content I18n.t('devise.confirmations.confirmed')

  end
end