# ITE 014 - Information Management

## Creating Tables and Objects
In the _schema folder, run the following files:
1. create_tables.sql
2. create_triggers.sql

## Populating Tables with Data
Under _misc files/scripts run all files in the format populate_xxxx.sql in this order:
1. user, products, order (parent tables)
2. inventory, addresses, payments (child tables)
3. cart_items, order_items, transaction_history (all linked to inventory table)

## ~~Folder Structure~~ (Outdated)
~~`users` contain all queries related to user management~~

~~`inventory` contain all queries related to inventory management~~

~~`reports` contain all queries related to data aggregation and analytics~~

~~`transactions` contain procedures related to client transactions (cart, checkout, etc.)~~
