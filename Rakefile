require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test

task :setup do
  if File.exist?('.env')
    puts 'This will overwrite your existing .env file'
  end
  print 'Enter your database name: [ams_benchmarks] '
  db_name = STDIN.gets.chomp
  print 'Enter your database user: [] '
  db_user = STDIN.gets.chomp
  print 'Enter your database password: [] '
  db_password = STDIN.gets.chomp
  print 'Enter your database server: [localhost] '
  db_server = STDIN.gets.chomp

  db_name = 'ams_benchmarks' if db_name.empty?
  db_password = ":#{db_password}" unless db_password.empty?
  db_server = 'localhost' if db_server.empty?

  db_server = "@#{db_server}" unless db_user.empty?

  env_path = File.expand_path('./.env')
  File.open(env_path, 'w') do |file|
    file.puts "DATABASE_NAME=#{db_name}"
    file.puts "DATABASE_URL=\"postgres://#{db_user}#{db_password}#{db_server}/#{db_name}\""
  end

  puts '.env file saved'
end

namespace :db do
  task :load_db_settings do
    require 'active_record'
    unless ENV['DATABASE_URL']
      require 'dotenv'
      Dotenv.load
    end
  end

  task :psql => :load_db_settings do
    exec "psql #{ENV['DATABASE_NAME']}"
  end

  task :drop => :load_db_settings do
    %x{ dropdb #{ENV['DATABASE_NAME']} }
  end

  task :create => :load_db_settings do
    %x{ createdb #{ENV['DATABASE_NAME']} }
  end

  task :migrate => :load_db_settings do
    ActiveRecord::Base.establish_connection

    ActiveRecord::Base.connection.create_table :notes, force: true do |t|
      t.string   "title"
      t.text     "content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    ActiveRecord::Base.connection.create_table :tags, force: true do |t|
      t.integer  "note_id", index: true
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    ActiveRecord::Base.connection.create_table :comments, force: true do |t|
      t.integer  "note_id", index: true
      t.string   "content"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    ActiveRecord::Base.connection.add_index :comments, [:id, :note_id]
    ActiveRecord::Base.connection.add_index :tags, [:id, :note_id]

    puts 'Database migrated'
  end

  task :seed => :load_db_settings do
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
    class Note < ActiveRecord::Base
    end
    Note.destroy_all
    1000.times do |index|
      Note.create title: "Note ##{index}", content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur felis arcu, viverra quis orci vel, eleifend iaculis lorem. Etiam hendrerit ornare ante et cursus. Ut id sem fringilla, rhoncus risus eget, lobortis orci. Nam est lacus, laoreet sed vestibulum sit amet, venenatis ut justo. Duis justo nibh, semper eget nisl eget, placerat iaculis augue. Mauris nec volutpat mauris. Aliquam a tempus metus. Integer malesuada scelerisque erat sed blandit. Maecenas vulputate mi non metus ullamcorper, in malesuada augue pretium. Integer ac est at nunc dapibus sagittis eget nec nisi. Proin egestas, ipsum vel imperdiet molestie, diam massa condimentum elit, et sollicitudin dolor risus at risus. Sed eu blandit felis. Aliquam eget euismod lectus.'
    end

    class Tag < ActiveRecord::Base
    end
    Tag.destroy_all
    10000.times do |index|
      Tag.create note_id: (index % 1000) + 1, name: "Tag ##{index}"
    end

    class Comment < ActiveRecord::Base
    end
    Comment.destroy_all
    10000.times do |index|
      Comment.create note_id: (index % 1000) + 1, content: "Comment ##{index}"
    end

    puts '1000 Notes and 10000 Tags/Comments'
  end
end
