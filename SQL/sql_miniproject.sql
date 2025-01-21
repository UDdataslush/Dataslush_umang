create database Library;
USE Library;

CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birth_date DATE,
    death_date DATE
);
-- Insert authors row
INSERT INTO authors (first_name, last_name, birth_date) VALUES
('J.K.', 'Rowling', '1965-07-31'),
('George', 'Orwell', '1903-06-25');
SELECT * FROM  authors;



CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    author_id INT,
    publication_year INT,
    genre VARCHAR(50),
    available_copies INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
-- Insert books row 
INSERT INTO books (title, author_id, publication_year, genre, available_copies) VALUES
('Harry Potter and the Philosopher''s Stone', 1, 1997, 'Fantasy', 10),
('1984', 2, 1949, 'Dystopian', 5);
SELECT * FROM books;



CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    membership_start_date DATE
);
-- Insert users row 
INSERT INTO users (first_name, last_name, email, membership_start_date) VALUES
('John', 'snow', 'john.snow@example.com', '2024-01-01'),
('emma', 'Smith', 'emma.smith@example.com', '2023-11-15');
SELECT * FROM users;



CREATE TABLE borrowings (
    borrowing_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    book_id INT,
    due_date DATE,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);
-- Insert borrowings row
INSERT INTO borrowings (user_id, book_id, borrow_date, due_date) VALUES
(1, 1, '2025-01-01', '2025-01-10'),
(2, 2, '2025-01-05', '2025-01-12');
SELECT * FROM borrowings;
