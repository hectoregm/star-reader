After do
  Mongoid.master.collections
    .select {|c| c.name !~ /system/ }.each(&:drop)
  User.create!(username: "hector", first_login: false)
end
