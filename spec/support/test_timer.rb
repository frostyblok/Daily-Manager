require "csv"

class TestTimer< RSpec::Core::Formatters::JsonFormatter
  RSpec::Core::Formatters.register self

  def close(_notification)
    with_headers = { write_headers: true, headers: ["Example", "Status", "Run Time", "Exceptions"] }
    CSV.open(output.path, "w", with_headers) do |csv|
      examples_grouped_by_file = @output_hash[:examples].group_by { |d| d[:id].sub(/\s*\[.+\]$/, "") }

      examples_grouped_by_file.each do |file_name, values|
        total_time = values.map { |f| f[:run_time] }.sum.round(6)
        statuses = values.map { |f| f[:status] }.uniq.join(", ")
        exceptions = values.map { |f| f[:exception] }.uniq.join(", ")
        csv << [file_name, statuses, total_time, exceptions]
      end
    end
  end
end

RSpec.configure do |c|
  c.add_formatter(TestTimer, "my_spec_log.csv")
end
