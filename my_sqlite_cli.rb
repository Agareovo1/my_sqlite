require 'readline'
require_relative "my_sqlite_request"

# Custom readline method with history management

def custom_readline_with_hist_management
    line = Readline.readline('my_sqlite_cli> ', true)
    if line =~ /^\s*$/ || Readline::HISTORY.to_a[-2] == line
      Readline::HISTORY.pop
    end
    line
  end

  def convert_array_to_hash(arr)
    result = {}
    arr.each do |item|
      left, right = item.split("=")
      result[left] = right
    end
    result
  end
  

  def execute_action(action_name, action_args, sql_request)
    case action_name
    when "from"
      execute_from_action(action_args, sql_request)
    when "select"
      execute_select_action(action_args, sql_request)
    when "where"
      execute_where_action(action_args, sql_request)
    when "order"
      execute_order_action(action_args, sql_request)
    when "join"
      execute_join_action(action_args, sql_request)
    when "insert"
      execute_insert_action(action_args, sql_request)
    when "values"
      execute_values_action(action_args, sql_request)
    when "update"
      execute_update_action(action_args, sql_request)
    when "set"
      execute_set_action(action_args, sql_request)
    when "delete"
      execute_delete_action(action_args, sql_request)
    else
      puts "Work in progress, don't have this statement yet :)"
      puts "If you want to quit - type quit."
    end
  end
  
  def execute_from_action(action_args, sql_request)
    if action_args.length != 1
      puts "Ex.: FROM students.csv"
    else
      sql_request.from(*action_args)
    end
  end
  
  def execute_select_action(action_args, sql_request)
    if action_args.length < 1
      puts "Ex.: SELECT name, age"
    else
      sql_request.select(action_args)
    end
  end

  def execute_where_action(action_args, sql_request)
    if action_args.length != 1
      puts "Ex.: WHERE column_name=value"
    else
      col, val = action_args[0].split("=")
      sql_request.where(col.strip, val.strip) # Add .strip to remove leading/trailing whitespaces
    end
  end
  
  
  def execute_order_action(action_args, sql_request)
    if action_args.length != 2
      puts "Ex.: ORDER age ASC"
    else
      col_name = action_args[0]
      sort_type = action_args[1].downcase
      sql_request.order(sort_type, col_name)
    end
  end
  
  def execute_join_action(action_args, sql_request)
    if action_args.length != 3 || action_args[1] != "ON"
      puts "Do better. Ex.: JOIN table ON col_a=col_b"
    else
      table = action_args[0]
      col_a, col_b = action_args[2].split("=")
      sql_request.join(col_a, table, col_b)
    end
  end
  
  def execute_insert_action(action_args, sql_request)
    if action_args.length != 1
      puts "Ex.: INSERT students.csv. Use VALUES"
    else
      sql_request.insert(*action_args)
    end
  end
  
  def execute_values_action(action_args, sql_request)
    if action_args.length < 1
      puts "Provide some data to insert. Ex.: name=BOB, birth_state=CA, age=90"
    else
      sql_request.values(convert_array_to_hash(action_args))
    end
  end
  
  def execute_update_action(action_args, sql_request)
    if action_args.length != 1
      puts "Ex.: UPDATE students.csv"
    else
      sql_request.update(*action_args)
    end
  end
  
  def execute_set_action(action_args, sql_request)
    if action_args.length < 1
      puts "Ex.: SET name=BOB. Use WHERE - otherwise WATCH OUT."
    else
      sql_request.set(convert_array_to_hash(action_args))
    end
  end
  
  def execute_delete_action(action_args, sql_request)
    if action_args.length != 0
      # conditional statement to confirm deletion of table
      puts "Ex.: DELETE FROM students.csv! Use WHERE - otherwise WATCH OUT."
    else
      sql_request.delete
    end
  end
  
  def execute_sql_command(sql)
    valid_actions = /^(SELECT|FROM|JOIN|WHERE|ORDER|INSERT|VALUES|UPDATE|SET|DELETE)$/i
    command = nil
    args = []
    request = MySqliteRequest.new
  
    sql.split.each do |part|
      if valid_actions.match?(part)
        if command
          args = args.join(' ').split(', ') unless command == 'JOIN'
          execute_action(command, args, request)
          command = nil
          args = []
        end
        command = part.downcase
      else
        args << part
      end
    end
  
    if args[-1]&.end_with?(';')
      args[-1] = args[-1].chomp(';')
      execute_action(command, args, request)
      request.execute_sql_request
    else
      puts 'Finish your request with ;'
    end
  end
  


  def mysqlite_cli
    puts "MySQLite version 0.2 2023-jul"
    while command = custom_readline_with_hist_management
      break if command == "quit"
      execute_sql_command(command)
    end
  end
  

mysqlite_cli()