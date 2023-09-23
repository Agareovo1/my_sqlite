# Welcome to My Sqlite
***

## Task
What is the problem? And where is the challenge?

We are to create a program that will mimic a real SQLite

database with support for all the basic SQLite functions like

SELECT,JOIN, UPDATE, DELETE and so on.

## Description
How have you solved the problem?

In solving the problem, we created a class called MySqliteRequest

which allows us to build a query progressively and ultimate execute the

query. Various methods were implemented in the Request file and we also

created a Command Line Interface which acts as the backend for the program

to run and the queries to be executed.


## Installation
How to install your project? npm install? make? make re?

The Installation of this program is quite straight forward 

1. We created our files using the mkdir command from the terminal 

2. Then we imported our nba_player_data.csv file from the question given 

3. We created a Request file and a Command Line Interface file to execute the program

4. In order to install (or run) our program, you need to start a terminal and input " ruby my_sqlite_cli.rb"

this will run the program and you can navigate further from there. 

## Usage
How does it work?
This program works by running the requests prompts through the Command Line Interface (CLI)
In order to test for the Request, we use the command below; 
     
        ruby my_sqlite_request 

then we add the tests to the my_sqlite_request file, here are examples of what to test for:

        NOTE: OUR RUN METHOD IS NAMED AS execute_sql_request. HENCE 

        Request.run is request.execute_sql_request

    
  request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('name')
  request.execute_sql_request

request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('name')
  request = request.where('college', 'University of California')
  request.execute_sql_request

request = MySqliteRequest.new
  request = request.from('nba_player_data.csv')
  request = request.select('name')
  request = request.where('college', 'University of California')
  request = request.where('year_start', '1997')
  request.execute_sql_request

request = MySqliteRequest.new
  request = request.insert('nba_player_data.csv')
  request = request.values('name' => 'Alaa Abdelnaby', 'year_start' => '1991', 'year_end' => '1995', 'position' => 'F-C', 'height' => '6-10', 'weight' => '240', 'birth_date' => "June 24, 1968", 'college' => 'Duke University')
  request.execute_sql_request

request = MySqliteRequest.new
  request = request.update('nba_player_data.csv')
  request = request.values('name' => 'Alaa Renamed')
  request = request.where('name', 'Alaa Abdelnaby')
  request.execute_sql_request

request = MySqliteRequest.new
  request = request.delete()
  request = request.from('nba_player_data.csv')
  request = request.where('name', 'Alaa Abdelnaby')
  request.execute_sql_request


In order to run CLI, we use the command below

        ruby my_sqlite_cli.rb

        my_sqlite_cli> SELECT * FROM students.csv   

        my_sqlite_cli> SELECT name,email FROM students WHERE name = 'Mila'

        my_sqlite_cli> INSERT INTO students VALUES (John,john@johndoe.com,A,https://blog.johndoe.com)

        my_sqlite_cli> UPDATE students SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Mila'

        my_sqlite_cli> DELETE FROM students WHERE name = 'John'

# to quit CLI
my_sqlite_cli> quit

/my_project argument1 argument2

### The Core Team
Agare Success 
Olasunkanmi Adebiyi


<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px'></span>
