json.extract! article, :id, :path, :title, :text, :picture, :code, :created_at, :updated_at
json.url article_url(article, format: :json)