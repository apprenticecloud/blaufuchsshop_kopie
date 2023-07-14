require 'csv'

namespace :import do
  desc "Import Schools"
  task :schools, [:file] => :environment do |t, args|

    CSV.foreach(args.file, headers: true, col_sep: ';') do |row|
      school = School.create(name: row[0])
      school.create_address(street_address: row[1], postal_code: row[2], address_locality: row[3])

      school.save
      puts "#{school.id}, #{school.name}"
    end

  end
end
