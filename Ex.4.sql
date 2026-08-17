mysql> CREATE DATABASE LibraryDB;
ERROR 1007 (HY000): Can't create database 'LibraryDB'; database exists
mysql> USE LibraryDB;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> 
mysql> CREATE TABLE Authors (
    ->     AuthorID INT PRIMARY KEY,
    ->     Name VARCHAR(100)
    -> );
ERROR 1050 (42S01): Table 'Authors' already exists
mysql> 
mysql> CREATE TABLE Books (
    ->     BookID INT PRIMARY KEY,
    ->     Title VARCHAR(150),
    ->     AuthorID INT,
    ->     FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
    -> );
ERROR 1050 (42S01): Table 'Books' already exists
mysql> 
mysql> CREATE TABLE Borrowers (
    ->     BorrowerID INT PRIMARY KEY,
    ->     Name VARCHAR(100)
    -> );
ERROR 1050 (42S01): Table 'Borrowers' already exists
mysql> 
mysql> CREATE TABLE BookBorrowing (
    ->     BookID INT,
    ->     BorrowerID INT,
    ->     BorrowedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ->     FOREIGN KEY (BookID) REFERENCES Books(BookID),
    ->     FOREIGN KEY (BorrowerID) REFERENCES Borrowers(BorrowerID)
    -> );
ERROR 1050 (42S01): Table 'BookBorrowing' already exists
mysql> 
mysql> INSERT INTO Authors (AuthorID, Name)
    -> VALUES
    -> (1, 'J.K. Rowling'),
    -> (2, 'George Orwell'),
    -> (3, 'J.R.R. Tolkien');
ERROR 1062 (23000): Duplicate entry '1' for key 'Authors.PRIMARY'
mysql> 
mysql> INSERT INTO Books (BookID, Title, AuthorID)
    -> VALUES
    -> (101, 'Harry Potter and the Philosopher\'s Stone', 1),
    -> (102, '1984', 2),
    -> (103, 'The Hobbit', 3),
    -> (104, 'Harry Potter and the Chamber of Secrets', 1);
ERROR 1062 (23000): Duplicate entry '101' for key 'Books.PRIMARY'
mysql> 
mysql> INSERT INTO Borrowers (BorrowerID, Name)
    -> VALUES
    -> (1, 'John Doe'),
    -> (2, 'Jane Smith'),
    -> (3, 'Alice Johnson');
ERROR 1062 (23000): Duplicate entry '1' for key 'Borrowers.PRIMARY'
mysql> 
mysql> INSERT INTO BookBorrowing (BookID, BorrowerID)
    -> VALUES
    -> (101, 1),
    -> (102, 2),
    -> (103, 3),
    -> (104, 1);
Query OK, 4 rows affected (0.00 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM Authors;
+----------+----------------+
| AuthorID | Name           |
+----------+----------------+
|        1 | J.K. Rowling   |
|        2 | George Orwell  |
|        3 | J.R.R. Tolkien |
+----------+----------------+
3 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM Books;
+--------+------------------------------------------+----------+
| BookID | Title                                    | AuthorID |
+--------+------------------------------------------+----------+
|    101 | Harry Potter and the Philosopher's Stone |        1 |
|    102 | 1984                                     |        2 |
|    103 | The Hobbit                               |        3 |
|    104 | Harry Potter and the Chamber of Secrets  |        1 |
+--------+------------------------------------------+----------+
4 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM Borrowers;
+------------+---------------+
| BorrowerID | Name          |
+------------+---------------+
|          1 | John Doe      |
|          2 | Jane Smith    |
|          3 | Alice Johnson |
+------------+---------------+
3 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM BookBorrowing;
+--------+------------+---------------------+
| BookID | BorrowerID | BorrowedDate        |
+--------+------------+---------------------+
|    101 |          1 | 2026-08-17 14:22:02 |
|    102 |          2 | 2026-08-17 14:22:02 |
|    103 |          3 | 2026-08-17 14:22:02 |
|    104 |          1 | 2026-08-17 14:22:02 |
|    101 |          1 | 2026-08-17 14:24:39 |
|    102 |          2 | 2026-08-17 14:24:39 |
|    103 |          3 | 2026-08-17 14:24:39 |
|    104 |          1 | 2026-08-17 14:24:39 |
|    101 |          1 | 2026-08-17 14:27:21 |
|    102 |          2 | 2026-08-17 14:27:21 |
|    103 |          3 | 2026-08-17 14:27:21 |
|    104 |          1 | 2026-08-17 14:27:21 |
|    101 |          1 | 2026-08-17 14:28:51 |
|    102 |          2 | 2026-08-17 14:28:51 |
|    103 |          3 | 2026-08-17 14:28:51 |
|    104 |          1 | 2026-08-17 14:28:51 |
|    101 |          1 | 2026-08-17 14:33:20 |
|    102 |          2 | 2026-08-17 14:33:20 |
|    103 |          3 | 2026-08-17 14:33:20 |
|    104 |          1 | 2026-08-17 14:33:20 |
+--------+------------+---------------------+
20 rows in set (0.00 sec)

mysql> 
mysql> SELECT UPPER(b.Title) AS Title, a.Name AS Author
    -> FROM Books b
    -> INNER JOIN Authors a
    -> ON b.AuthorID = a.AuthorID;
+------------------------------------------+----------------+
| Title                                    | Author         |
+------------------------------------------+----------------+
| HARRY POTTER AND THE PHILOSOPHER'S STONE | J.K. Rowling   |
| HARRY POTTER AND THE CHAMBER OF SECRETS  | J.K. Rowling   |
| 1984                                     | George Orwell  |
| THE HOBBIT                               | J.R.R. Tolkien |
+------------------------------------------+----------------+
4 rows in set (0.00 sec)

mysql> 
mysql> SELECT Name,
    -> (SELECT COUNT(*)
    ->  FROM Books
    ->  WHERE Books.AuthorID = Authors.AuthorID) AS NumberOfBooks
    -> FROM Authors;
+----------------+---------------+
| Name           | NumberOfBooks |
+----------------+---------------+
| J.K. Rowling   |             2 |
| George Orwell  |             1 |
| J.R.R. Tolkien |             1 |
+----------------+---------------+
3 rows in set (0.00 sec)

mysql> 
mysql> SELECT Title
    -> FROM Books
    -> WHERE BookID IN (
    ->     SELECT BookID
    ->     FROM BookBorrowing
    ->     WHERE BorrowerID = (
    ->         SELECT BorrowerID
    ->         FROM Borrowers
    ->         WHERE Name = 'John Doe'
    ->     )
    -> );
+------------------------------------------+
| Title                                    |
+------------------------------------------+
| Harry Potter and the Philosopher's Stone |
| Harry Potter and the Chamber of Secrets  |
+------------------------------------------+
2 rows in set (0.00 sec)

mysql> 
mysql> SELECT
    ->     b.Title,
    ->     COALESCE(bb_data.Name, 'Not Borrowed') AS Borrower
    -> FROM Books b
    -> LEFT JOIN (
    ->     SELECT bb.BookID, br.Name
    ->     FROM BookBorrowing bb
    ->     JOIN Borrowers br
    ->     ON bb.BorrowerID = br.BorrowerID
    -> ) AS bb_data
    -> ON b.BookID = bb_data.BookID;
+------------------------------------------+---------------+
| Title                                    | Borrower      |
+------------------------------------------+---------------+
| Harry Potter and the Philosopher's Stone | John Doe      |
| Harry Potter and the Philosopher's Stone | John Doe      |
| Harry Potter and the Philosopher's Stone | John Doe      |
| Harry Potter and the Philosopher's Stone | John Doe      |
| Harry Potter and the Philosopher's Stone | John Doe      |
| 1984                                     | Jane Smith    |
| 1984                                     | Jane Smith    |
| 1984                                     | Jane Smith    |
| 1984                                     | Jane Smith    |
| 1984                                     | Jane Smith    |
| The Hobbit                               | Alice Johnson |
| The Hobbit                               | Alice Johnson |
| The Hobbit                               | Alice Johnson |
| The Hobbit                               | Alice Johnson |
| The Hobbit                               | Alice Johnson |
| Harry Potter and the Chamber of Secrets  | John Doe      |
| Harry Potter and the Chamber of Secrets  | John Doe      |
| Harry Potter and the Chamber of Secrets  | John Doe      |
| Harry Potter and the Chamber of Secrets  | John Doe      |
| Harry Potter and the Chamber of Secrets  | John Doe      |
+------------------------------------------+---------------+
20 rows in set (0.00 sec)

mysql> 
mysql> SELECT DISTINCT br.Name
    -> FROM Borrowers br
    -> WHERE EXISTS (
    ->     SELECT 1
    ->     FROM BookBorrowing bb
    ->     JOIN Books b
    ->     ON bb.BookID = b.BookID
    ->     WHERE b.AuthorID = (
    ->         SELECT AuthorID
    ->         FROM Authors
    ->         WHERE Name = 'J.K. Rowling'
    ->     )
    ->     AND bb.BorrowerID = br.BorrowerID
    -> );
+----------+
| Name     |
+----------+
| John Doe |
+----------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT Title
    -> FROM Books
    -> WHERE EXISTS (
    ->     SELECT 1
    ->     FROM BookBorrowing bb
    ->     WHERE bb.BookID = Books.BookID
    -> );
+------------------------------------------+
| Title                                    |
+------------------------------------------+
| Harry Potter and the Philosopher's Stone |
| 1984                                     |
| The Hobbit                               |
| Harry Potter and the Chamber of Secrets  |
+------------------------------------------+
4 rows in set (0.00 sec)

mysql> 
mysql> SELECT Title
    -> FROM Books
    -> WHERE NOT EXISTS (
    ->     SELECT 1
    ->     FROM BookBorrowing bb
    ->     WHERE bb.BookID = Books.BookID
    -> );


