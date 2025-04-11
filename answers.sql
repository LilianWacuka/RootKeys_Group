CREATE DATABASE bookdb;
USE bookdb;

-- ===========================================
-- FAITH'S SECTION: FIRST FIVE TABLES SETUP
-- ===========================================

-- Table 1: publisher
-- Stores a list of publishers for books
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table 2: book_language
-- Stores a list of possible book languages
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100) NOT NULL
);

-- Table 3: author
-- Stores all authors in the system
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

-- Table 4: book
-- Stores a list of all books in the store
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    language_id INT,
    price DECIMAL(10, 2),

    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

-- Table 5: book_author
-- Manages many-to-many relationship between books and authors
CREATE TABLE book_author (
    book_id INT,
    author_id INT,

    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- ========================================
-- USER MANAGEMENT SECTION
-- ========================================

-- Create user: faith_dev (developer - full access)
CREATE USER 'faith_dev'@'localhost' IDENTIFIED BY '123!';
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'faith_dev'@'localhost';

-- Create user: data_entry (can insert/update data only)
CREATE USER 'data_entry'@'localhost' IDENTIFIED BY '456!';
GRANT SELECT, INSERT, UPDATE ON bookstore_db.* TO 'data_entry'@'localhost';

-- Create user: viewer (read-only access)
CREATE USER 'viewer'@'localhost' IDENTIFIED BY '789!';
GRANT SELECT ON bookstore_db.* TO 'viewer'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- ========================================
--  Insert sample data into each table
-- ========================================

/* --- Insert into publisher --- */
INSERT INTO publisher (name)
VALUES 
    ('Penguin Books'),
    ('O\'Reilly Media'),
    ('HarperCollins'),
    ('Random House'),
    ('Simon & Schuster');

/* --- Insert into book_language --- */
INSERT INTO book_language (language_name)
VALUES 
    ('English'),
    ('Spanish'),
    ('French'),
    ('German'),
    ('Swahili');

/* --- Insert into author --- */
INSERT INTO author (first_name, last_name)
VALUES 
    ('George', 'Orwell'),
    ('Jane', 'Austen'),
    ('Chinua', 'Achebe'),
    ('J.K.', 'Rowling'),
    ('Gabriel', 'Garcia Marquez');

/* --- Insert into book --- */
INSERT INTO book (title, publisher_id, language_id, price)
VALUES 
    ('1984', 1, 1, 19.99),
    ('Pride and Prejudice', 2, 1, 14.50),
    ('Things Fall Apart', 3, 5, 22.00),
    ('Harry Potter and the Sorcerer\'s Stone', 4, 1, 29.99),
    ('One Hundred Years of Solitude', 5, 3, 25.75);

/* --- Insert into book_author --- */
INSERT INTO book_author (book_id, author_id)
VALUES 
    (1, 1),  -- 1984 by George Orwell
    (2, 2),  -- Pride and Prejudice by Jane Austen
    (3, 3),  -- Things Fall Apart by Chinua Achebe
    (4, 4),  -- Harry Potter by J.K. Rowling
    (5, 5);  -- One Hundred Years of Solitude by Gabriel Garcia Marquez

-- ========================================
-- TESTING QUERIES SECTION
-- ========================================

-- 1. Retrieve all books from the store
SELECT * FROM book;

-- 2. Retrieve all authors with their full names (first and last) 
SELECT CONCAT(first_name, ' ', last_name) AS author_name FROM author;

-- 3. Retrieve all books with their authors' full names
SELECT  
    b.title AS book_title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name
FROM  
    book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id
LIMIT 0, 1000;

-- 4. List all books along with the language they are written in
SELECT 
    b.title AS book_title,
    l.language_name
FROM 
    book b
JOIN book_language l ON b.language_id = l.language_id;

-- 5. Count the number of books published by each publisher
SELECT  
    p.name AS publisher_name,
    COUNT(b.book_id) AS number_of_books
FROM  
    publisher p
LEFT JOIN book b ON p.publisher_id = b.publisher_id
GROUP BY p.name
LIMIT 0, 1000;