# db/seed.rb

puts "Seeding database..."

# Get a list of all migration versions
all_versions = ActiveRecord::MigrationContext.new('db/migrate').get_all_versions

# Exclude the problematic migration version
excluded_version = '20230511174738'
migrated_versions = all_versions.reject { |v| v == excluded_version }

# Run migrations up to the latest version excluding the problematic migration
ActiveRecord::MigrationContext.new('db/migrate').migrate(migrated_versions)

# Your seed data and logic go here
puts "Database seeding complete."
