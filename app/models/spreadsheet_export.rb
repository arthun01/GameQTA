require "csv"

class SpreadsheetExport
  def self.row(values)
    CSV.generate_line(values.map { |value| value.is_a?(String) ? text(value) : value }, force_quotes: true)
  end

  def self.text(value)
    normalized = value.unicode_normalize(:nfkc)
    if normalized.match?(/\A[\p{Space}\p{Cc}\p{Cf}]*[=+\-@]/) || normalized.match?(/\A[\t\r\n]/)
      "'#{value}"
    else
      value
    end
  end
end
