require 'csv'
require_relative "data_manipulator"

class MySqliteRequest
    def initialize
        @table_name = nil
        @request = nil
    end

    def from(table_name)
        if table_name == nil
            puts "Provide existing table. Example.: students.csv"
        else
            @table_name = table_name
        end
        return self
    end
    
    def select(columns)
        if columns == nil
            puts "Select column(s)."
        else
            @request = 'select'
            @columns = columns
        end
        return self
    end

    def where(column, value)
        @where = {column: column, value: value}
        return self
    end

    def join(column_on_db_a, filename_db_b, column_on_db_b)
        @join = {column_a: column_on_db_a, column_b: column_on_db_b}
        @table_name_join = filename_db_b
        return self
    end

    def order(order, column_name)
        @order_request = {order: order, column_name: column_name}
        return self
    end

    def insert(table_name)
        @request = 'insert'
        @table_name = table_name
        return self
    end

    def values(data)
        @data = data
        return self
    end

    def update(table_name)
        @request = 'update'
        @table_name = table_name
        return self
    end

    def set(data)
        @data = data
        return self
    end

    def delete
        @request = 'delete'
        return self
    end

    def join_tables
        parsed_csv_a = load_csv_data(@table_name)
        parsed_csv_b = load_csv_data(@table_name_join)
      
        parsed_csv_b.each do |row|
          criteria = {@join[:column_a] => row[@join[:column_b]]}
          row.delete(@join[:column_b])
          update_rows_matching_criteria(parsed_csv_a, criteria, row)
        end
      
        return parsed_csv_a
      end
      

      def print_result(result)
        if result.nil? || result.empty?
          puts "There is no result for this request."
        else
          headers = result.first.keys
          separator = "-" * (headers.join(' | ').length)
      
          puts headers.join(' | ')
          puts separator
      
          result.each do |row|
            puts row.values.join(' | ')
          end
      
          puts separator
        end
      end
      

      def execute_sql_request
        if @table_name.nil?
          puts "request must contain a table."
          return
        end
      
        parsed_csv = load_csv_data(@table_name)
      
        case @request
        when 'select'
          if @join
            parsed_csv = execute_join_request
          end
          if @order_request
            parsed_csv = order_hashes_by_column(parsed_csv, @order_request[:order], @order_request[:column_name])
          end
          if @where
            parsed_csv = filter_hashes_by_criteria(parsed_csv, {@where[:column] => @where[:value]})
          end
          if @columns && @table_name
            result = filter_columns_from_hashes(parsed_csv, @columns)
            print_result(result)
          else
            puts "you must Provide columns to SELECT"
          end
      
        when 'insert'
          if @data
            parsed_csv = append_hash_to_list(parsed_csv, @data)
          end
          write_csv_data_to_file(parsed_csv, @table_name)
      
        when 'update'
          if @where
            @where = {@where[:column] => @where[:value]}
          end
          parsed_csv = update_rows_matching_criteria(parsed_csv, @where, @data)
          write_csv_data_to_file(parsed_csv, @table_name)
      
        when 'delete'
          if @where
            @where = {@where[:column] => @where[:value]}
          end
          parsed_csv = filter_out_rows_by_criteria(parsed_csv, @where)
          write_csv_data_to_file(parsed_csv, @table_name)
      
        else
          puts "Invalid request please. Work in progress, don't have this statement yet :)"
        end
      
        # Reset all the instance variables for the next command
        @request = nil
        @where = nil
        @table_name = nil
        @data = nil
        @join = nil
      end
    end

      
         

# request = MySqliteRequest.new
# request = request.from('nba_player_data.csv')
# request = request.select('name')
# request.execute_sql_request