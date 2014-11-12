require 'spec_helper'

feature Lodging do
  let!(:conference) { create(:conference) }
  let!(:organizer_role) { create(:organizer_role, resource: conference) }
  let!(:organizer) { create(:user, role_ids: [organizer_role.id]) }

  scenario 'Add a lodging', feature: true, js: true do
    path = "#{Rails.root}/app/assets/images/rails.png"

    conference.venue = create(:venue)
    sign_in organizer
    visit admin_conference_lodgings_path(
              conference_id: conference.short_title)
    # Add lodging
    click_link 'Add Lodging'

    fill_in 'lodging_name', with: 'New lodging'
    fill_in 'lodging_description', with: 'This is the lodging description'
    fill_in 'lodging_website_link', with: 'http:\\www.google.com'
    attach_file 'Photo', path

    click_button 'Create Lodging'

    # Validations
    expect(flash).to eq('Lodging successfully created.')
    expect(page.has_content?('New lodging')).to be true
    expect(page.has_content?('This is the lodging description')).to be true
    expect(page.has_content?('Go to Website')).to be true
    expect(Lodging.count).to eq(1)
  end

  scenario 'Update a lodging', feature: true, js: true do
    path = "#{Rails.root}/app/assets/images/rails.png"

    venue = create(:venue)
    lodging = create(:lodging, venue: conference.venue)
    conference.venue = venue

    sign_in organizer
    visit admin_conference_lodgings_path(
              conference_id: conference.short_title)

    expect(page.has_content?('Example Hotel')).to be true

    # Add lodging
    click_link 'Example Hotel'
    click_link 'Edit'

    fill_in 'lodging_name', with: 'New lodging'
    fill_in 'lodging_description', with: 'This is the lodging description'
    fill_in 'lodging_website_link', with: 'http:\\www.google.com'
    attach_file 'Photo', path

    click_button 'Update Lodging'

    # Validations
    expect(flash).to eq('Lodging successfully updated.')
    expect(page.has_content?('New lodging')).to be true
    expect(page.has_content?('This is the lodging description')).to be true
    expect(page.has_content?('Go to Website')).to be true
    lodging.reload
    expect(lodging.name).to eq('New lodging')
    expect(lodging.description).to eq('This is the lodging description')
    expect(lodging.website_link).to eq('http:\\www.google.com')
    expect(Lodging.count).to eq(1)
  end

  scenario 'Delete a lodging', feature: true, js: true do
    venue = create(:venue)
    create(:lodging, venue: conference.venue)
    conference.venue = venue

    sign_in organizer
    visit admin_conference_lodgings_path(
              conference_id: conference.short_title)

    expect(page.has_content?('Example Hotel')).to be true

    # Add lodging
    click_link 'Delete'

    # Validations
    expect(flash).to eq('Lodging successfully deleted.')
    expect(page.has_content?('Example Hotel')).to be false
    expect(Lodging.count).to eq(0)
  end
end
