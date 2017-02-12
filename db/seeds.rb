# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default
# values. The data can then be loaded with the rake db:seed (or created alongside the db with
# db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def debug(message)
  puts message unless Rails.env.test?
end

debug 'Creating template'
temp = Template.find_or_create_by(name: 'johanneskroop.de')
temp.html_begin = '<h1>'
temp.html_end = '</h1>'
temp.save!

debug 'Creating aricles'
index = Article.find_or_create_by(path: 'index')
index.text = 'Hello World!'
index.template = temp
index.save!
