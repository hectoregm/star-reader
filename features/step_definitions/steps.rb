Given 'I am a star user' do
end

Given 'I am a star user with archived stars' do
  Star.create!(source: 'twitter',
                   source_id: '48324230',
                   image_url: "/images/twitter.png",
                   author: 'hectoregm',
                   author_url: 'hectoregm.com',
                   content: 'Tweet Tweet',
                   archived: true,
                   ocreated_at: Time.now)
end

Given "I am a star user login with zero archived stars" do
end

Given 'I go to the archive' do
  visit('/archive')
  within('.tabs') do
    page.should have_selector('#archive.active')
  end
end

When 'I go to my stars' do
  visit('/stars')
end

When 'I click Archive in a star' do
  page.execute_script("jQuery.fx.off = true;")
  @id = find('.star-item:first-child')[:"data-id"]
  within('.star-item:first-child') do
    click_link('Archive')
  end
end

When 'I click Unarchive in an archived star' do
  page.execute_script("jQuery.fx.off = true;")
  within('.star-item:first-child') do
    click_link('Unarchive')
  end
end

Then 'the star is removed from the stream' do
  wait_until(40) do
    find('.star-item:first-child').visible?.should be_false
  end
end

Then /^I will see my stars$/ do
  page.should have_selector('.star-item[data-source="twitter"]')
  page.should have_selector('.star-item[data-source="greader"]')
end

When /^I click the Archive tab$/ do
  click_link('archive')
end

Then /^I will see no archived stars$/ do
  within('.star-stream') do
    page.should have_content('No archived stars.')
  end
end

Then 'that star is shown' do
  within('.star-stream') do
    page.should have_no_content('No archived stars.')
    find('.star-item')[:"data-id"].should == @id
  end
end
