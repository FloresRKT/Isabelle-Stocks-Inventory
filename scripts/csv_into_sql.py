import csv, os

csv_name = input("File name (include .csv): ")

table_name = input("Table name: ")

script_dir = os.path.dirname(__file__)  # Folder of the current script
parent_dir = os.path.dirname(script_dir)  # Go up 1 level
csv_path = os.path.join(parent_dir, 'data', csv_name)
output_sql_path = os.path.join(script_dir, 'populate_' + csv_name.replace('.csv', '.sql'))

columns = []

print("Enter column names, press enter when done:")
while True:
    column_name = input("> ")
    if (column_name != ""):
        columns.append(column_name)
    else:
        break

with open(csv_path, 'r') as f, open(output_sql_path, 'w') as sql_file:
    reader = csv.reader(f)
    next(reader)  # Skip header
    for row in reader:
        values = []
        for val in row:
            if val == '':  # Handle NULLs
                values.append("NULL")
            elif val.isdigit():  # Numbers
                values.append(val)
            else:  # Strings/Dates
                val = val.replace("'", "''")  # Escape single quotes
                values.append(f"'{val}'")
        
        # Write INSERT statement to the SQL file
        sql = f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({', '.join(values)});\n"
        sql_file.write(sql)

print(f"SQL statements saved to: {output_sql_path}")