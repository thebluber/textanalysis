DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:#{Sinatra::Application.root}/db/data.db")
DataMapper.auto_upgrade!
