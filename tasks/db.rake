namespace :db do
  namespace :migrate do
    desc 'Migrate up to a specific migration number' if defined? DataMapper
    task :up, :number do |t, args|
      require 'dm-migrations/migration_runner'
      Dir["#{ROOT_PATH}/db/migrations/*.rb"].each { |m| require m }
      args.number == nil ? migrate_up! : migrate_up!(args.number)
    end

    desc 'Migrate down to a specific migration number' if defined? DataMapper
    task :down, :number do |t, args|
      require 'dm-migrations/migration_runner'
      Dir["#{ROOT_PATH}/db/migrations/*.rb"].each { |m| require m }
      args.number == nil ? migrate_down! : migrate_down!(args.number)
    end
  end

  desc 'Run one or all /data/seeds scripts' if defined? DataMapper
  task :seed, :file do |t, args|
    if args.file == nil
      Dir["#{ROOT_PATH}/db/seeds/*.rb"].each { |m| require m }
    else
      require "./data/seeds/#{args.file}"
    end
  end
end
