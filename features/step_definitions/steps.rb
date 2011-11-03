Given /^I am a star user$/ do
end

When /^I go to my favorites$/ do
  visit('/')
end

Then /^I will see my favorites$/ do
  page.should have_selector('.star-item[data-source="twitter"]')
  page.should have_selector('.star-item[data-source="greader"]')
end
