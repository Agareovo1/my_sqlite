require 'csv'

# Custom error class for handling file not found error
class FileNotFound < StandardError
  def message
    "File not found."
  end
end

# Custom method to load CSV data into an array of hashes
def load_csv_data(db_name)
  begin
    unless File.exist?(db_name)
      raise FileNotFound
    end

    list_of_hashes = []
    CSV.foreach(db_name, headers: true) do |row|
      list_of_hashes << row.to_h
    end

    return list_of_hashes
  rescue FileNotFound => e
    puts e.message
    return []
  end
end

# Method to write CSV data to a file
def write_csv_data_to_file(list_of_hashes, db_name)
  return if list_of_hashes.empty?

  keys_written = false
  CSV.open(db_name, "w", headers: true) do |csv|
    list_of_hashes.each do |hash|
      unless keys_written
        csv << hash.keys
        keys_written = true
      end
      csv << hash.values
    end
  end
end

# Method to filter selected columns from an array of hashes
def filter_columns_from_hashes(list_of_hashes, list_of_columns)
  return [] if list_of_hashes.nil?

  result = []
  list_of_hashes.each do |hash|
    if list_of_columns[0] == "*"
      result << hash
    else
      new_hash = hash.select { |key, _value| list_of_columns.include?(key) }
      result << new_hash
    end
  end

  return result
end

# Method to order an array of hashes by a specified column
def order_hashes_by_column(list_of_hashes, order_type, column)
  return list_of_hashes if list_of_hashes.empty?

  sorted_hashes = list_of_hashes.sort_by { |hash| hash[column] }

  if order_type == "desc"
    sorted_hashes.reverse!
  end

  return sorted_hashes
end

# Method to append a hash to an array of hashes
def append_hash_to_list(list_of_hashes, new_hash)
  return list_of_hashes + [new_hash]
end

# Method to check if a hash matches a given criteria
def hash_matches_criteria?(line_from_list, criteria_hash)
  return true if criteria_hash.nil?

  criteria_hash.all? { |key, value| line_from_list[key] == value }
end

# Method to update a hash with new data
def update_hash_data(line_from_list, update_hash)
  merged_hash = line_from_list.merge(update_hash)
  return merged_hash
end

# Method to update rows in an array of hashes that match certain criteria
def update_rows_matching_criteria(list_of_hashes, criteria_hash, update_hash)
  result = list_of_hashes.map do |row|
    if hash_matches_criteria?(row, criteria_hash)
      update_hash_data(row, update_hash)
    else
      row
    end
  end

  return result
end

# Method to filter rows from an array of hashes based on a given criteria
def filter_hashes_by_criteria(data, criteria)
    data.select do |row|
      criteria.all? { |key, value| row[key.to_sym] == value } # Convert key to symbol to match CSV headers
    end
  end
  

# Method to filter out rows from an array of hashes based on a given criteria
def filter_out_rows_by_criteria(list_of_hashes, criteria_hash)
  return list_of_hashes if criteria_hash.nil?

  result = list_of_hashes.reject { |row| hash_matches_criteria?(row, criteria_hash) }
  return result
end
