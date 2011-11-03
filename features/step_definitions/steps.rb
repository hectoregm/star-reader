Given /^I am a twitter user$/ do
end

When /^I go to the dashboard$/ do
  visit('/')
end

Then /^I will see my favorite tweets$/ do
  page.should have_selector('.star-item')
end
