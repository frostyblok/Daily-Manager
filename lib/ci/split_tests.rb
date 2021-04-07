require 'csv'

class SplitTests
  def initialize(index:, concurrency:)
    @index = index
    @concurrency = concurrency
  end

  def split
    remove_old_specs
    add_new_specs
    all_suites = create_suites
    add_initial_tests(all_suites: all_suites)
    add_suites_until_empty(all_suites: all_suites)

    all_suites.each(&:compact!)

    all_suites = all_suites[index_int].map { |f| f[0] = f[0].sub("./", "") }
    all_suites
  end

  def index_int
    @index_int ||= @index.to_i
  end

  def concurrency_int
    @concurrency_int ||= @concurrency.to_i
  end

  def read_csv
    file = Rails.root.join("my_spec_log.csv")
    CSV.read(file)
  end

  def csv
    csv = read_csv
    csv.map(&:pop)
    csv.shift
    csv.collect { |x| x[2] = x[2].to_f }
    csv = csv.sort_by { |x| x[2] }.reverse
    csv.map { |f| f[0] = f[0].sub("./", "") }
    @csv ||= csv
  end

  def spec_files
    @spec_files ||= Dir["spec/**/*_spec.rb"] +
      Dir["engines/admin/spec/**/*_spec.rb"] +
      Dir["engines/support/spec/**/*_spec.rb"]
  end

  def not_tracked_specs
    @not_tracked_specs ||= spec_files.sort - csv.map(&:first).sort
  end

  def old_specs
    old_specs = []
    csv.each do |row|
      unless spec_files.include?(row[0])
        old_specs << row
      end
    end
    old_specs
  end

  def remove_old_specs
    old_specs.each do |spec|
      deleted_row = csv.delete(spec)
      puts "#{deleted_row} deleted"
    end
  end

  def add_new_specs
    not_tracked_specs.each do |spec|
      csv << [spec, "new", 0]
    end
  end

  def create_suites
    all_suites = []
    concurrency_int.times do
      all_suites << []
    end
    @create_suites ||= all_suites
  end

  def add_initial_tests(all_suites:)
    concurrency_int.times do |number|
      all_suites[number] << csv.shift
    end
  end

  def add_suites_until_empty(all_suites:)
    until csv.empty?
      all_suites = all_suites.sort_by { |f| f.map { |x| x[2] }.sum }
      all_suites.first << csv.shift
    end
  end
end
