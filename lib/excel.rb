require 'csv'

class SheetToArray
  def self.convert (filepath, format=nil)
    ext = format ? format : filepath.split('.').last

    if respond_to?(ext)
      send(ext, filepath)
    else
      return -1
    end
  end

  private

  def self.xls (filepath)
    book = Spreadsheet.open filepath
    sheet = book.worksheet 0

    result = []

    sheet.each do |row|
      result << row.to_a
    end

    result
  end

  def self.xlsx (filepath)
    book = RubyXL::Parser.parse filepath, :skip_filename_check => true
    book.worksheets[0].extract_data
  end

  def self.csv (file)
    result = []

    CSV.foreach(file) do |row|
      result << row.to_a
    end

    result
  end
end
