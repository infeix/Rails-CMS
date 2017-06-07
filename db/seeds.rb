def debug(message)
  puts message unless Rails.env.test?
end

debug 'Creating template'
temp = Template.find_or_create_by(title: 'test')
temp.save!

css1 = CssPart.find_or_create_by(index: 1, template_id: temp.id)
css1.title = 'test_css'
css1.text = '
h1,
h2,
h3,
h4,
h5,
h6,
label {
    color: red;
}
'
css1.save!

part1 = HtmlPart.find_or_create_by(index: 1, template_id: temp.id)
part1.text = '
    <h1 >'
part1.save!

# Part 2
part2 = HtmlPart.find_or_create_by(index: 2, template_id: temp.id)
part2.text = '
    </h1>
'
part2.save!

# Part 3

debug 'Creating index page'
index = Page.find_or_create_by(path: 'index')
index.title = 'Start'
index.template = temp
index.save!

art1 = Article.find_or_create_by(index: 1, page_id: index.id)
art1.text = '
Hallo CMS!
'
art1.save!

debug 'Creating Impressum page'
impressum = Page.find_or_create_by(path: 'impressum')
impressum.title = 'Impressum'
impressum.template = nil
impressum.save!

art_impressum = Article.find_or_create_by(index: 1, page_id: impressum.id)
art_impressum.text = '
<h1>Impressum</h1>
<p>
  <br>
  Name<br>
  Straße<br>
  Stadt<br>
  UST-ID: ****<br>
  <br>
  E-Mail: <a href="mailto:test@test.de">test@test.de</a><br>
  <br>
</p>'
art_impressum.save!

user = User.find_or_create_by(is_admin: true, email: 'admin@example.com')
user.password = 'secret42'
user.password_confirmation = 'secret42'
user.save!
