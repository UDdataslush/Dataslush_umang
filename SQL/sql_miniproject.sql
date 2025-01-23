CREATE DATABASE Library;
USE Library;

-- Authors Table
CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    birth_date DATE,
    death_date DATE
);

CREATE TABLE admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    hire_date DATE
);

-- Insert 5 sample admin rows
INSERT INTO admins (first_name, last_name, email, phone_number, hire_date) VALUES
('Alice', 'Johnson', 'alice.johnson@library.com', '123-456-1111', '2020-06-15'),
('Bob', 'Smith', 'bob.smith@library.com', '123-456-2222', '2018-04-10'),
('Catherine', 'Brown', 'catherine.brown@library.com', '123-456-3333', '2022-01-20'),
('Daniel', 'Wilson', 'daniel.wilson@library.com', '123-456-4444', '2019-09-05'),
('Emma', 'Davis', 'emma.davis@library.com', '123-456-5555', '2021-11-12');
-- Verify the admins table
SELECT * FROM admins;



CREATE TABLE book_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    requested_book_title VARCHAR(255),
    requested_author_name VARCHAR(255),
    request_date DATE,
    request_status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert 5 sample book requests
INSERT INTO book_requests (user_id, requested_book_title, requested_author_name, request_date) VALUES
(1, 'The Catcher in the Rye', 'J.D. Salinger', '2025-01-10'),
(2, 'The Alchemist', 'Paulo Coelho', '2025-01-12'),
(3, 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', '2025-01-14'),
(4, 'The Road', 'Cormac McCarthy', '2025-01-15'),
(5, 'A Brief History of Time', 'Stephen Hawking', '2025-01-16');
-- Verify the book_requests table
SELECT * FROM book_requests;

-- for view all book request
SELECT 
    br.request_id,
    u.first_name AS requester_first_name,
    u.last_name AS requester_last_name,
    br.requested_book_title,
    br.requested_author_name,
    br.request_date,
    br.request_status
FROM book_requests br
JOIN users u ON br.user_id = u.user_id;


-- for fetch pending book request
SELECT * 
FROM book_requests 
WHERE request_status = 'Pending';




-- Insert 20 authors
INSERT INTO authors (first_name, last_name, birth_date) VALUES
('J.K.', 'Rowling', '1965-07-31'),
('George', 'Orwell', '1903-06-25'),
('Jane', 'Austen', '1775-12-16'),
('Mark', 'Twain', '1835-11-30'),
('Agatha', 'Christie', '1890-09-15'),
('William', 'Shakespeare', '1564-04-23'),
('F. Scott', 'Fitzgerald', '1896-09-24'),
('Ernest', 'Hemingway', '1899-07-21'),
('Leo', 'Tolstoy', '1828-09-09'),
('Charles', 'Dickens', '1812-02-07'),
('J.R.R.', 'Tolkien', '1892-01-03'),
('Harper', 'Lee', '1926-04-28'),
('Oscar', 'Wilde', '1854-10-16'),
('Emily', 'Bronte', '1818-07-30'),
('Victor', 'Hugo', '1802-02-26'),
('Herman', 'Melville', '1819-08-01'),
('Arthur Conan', 'Doyle', '1859-05-22'),
('C.S.', 'Lewis', '1898-11-29'),
('Edgar Allan', 'Poe', '1809-01-19'),
('Gabriel', 'Garcia Marquez', '1927-03-06');

-- Books Table
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    author_id INT,
    publication_year INT,
    genre VARCHAR(50),
    available_copies INT,
    rating FLOAT, -- Added for Author popularity based on book ratings
    summary TEXT, -- Added for summary of books
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
DROP TABLE books;

-- Insert 20 books
INSERT INTO books (title, author_id, publication_year, genre, available_copies, rating, summary) VALUES
('Harry Potter and the Philosopher''s Stone', 1, 1997, 'Fantasy', 10, 4.9, 'A young wizard starts his journey.'),
('1984', 2, 1949, 'Dystopian', 5, 4.7, 'A chilling tale of a totalitarian regime.'),
('Pride and Prejudice', 3, 1813, 'Romance', 4, 4.6, 'A story of love and social standing.'),
('The Adventures of Tom Sawyer', 4, 1876, 'Adventure', 6, 4.4, 'Adventures of a young boy in a small town.'),
('Murder on the Orient Express', 5, 1934, 'Mystery', 8, 4.8, 'A classic whodunit aboard a luxury train.'),
('Hamlet', 6, 1603, 'Drama', 3, 4.5, 'The tragedy of the Prince of Denmark.'),
('The Great Gatsby', 7, 1925, 'Tragedy', 5, 4.7, 'The story of Jay Gatsby and his dream.'),
('The Old Man and the Sea', 8, 1952, 'Fiction', 4, 4.3, 'An epic battle between a man and a marlin.'),
('War and Peace', 9, 1869, 'Historical Fiction', 2, 4.6, 'A sweeping tale of Russian society.'),
('A Tale of Two Cities', 10, 1859, 'Historical Fiction', 6, 4.6, 'A story set in London and Paris during the French Revolution.'),
('The Hobbit', 11, 1937, 'Fantasy', 7, 4.8, 'A hobbit goes on an unexpected adventure.'),
('To Kill a Mockingbird', 12, 1960, 'Fiction', 5, 4.9, 'A young girl confronts prejudice in her town.'),
('The Picture of Dorian Gray', 13, 1890, 'Philosophical Fiction', 6, 4.4, 'A man trades his soul for eternal youth.'),
('Wuthering Heights', 14, 1847, 'Gothic Fiction', 3, 4.2, 'A tragic tale of love and revenge.'),
('Les Miserables', 15, 1862, 'Drama', 4, 4.8, 'A story of redemption set in post-revolutionary France.'),
('Moby Dick', 16, 1851, 'Adventure', 2, 4.3, 'A man''s obsession with a white whale.'),
('The Hound of the Baskervilles', 17, 1902, 'Mystery', 5, 4.6, 'A chilling mystery for Sherlock Holmes.'),
('The Chronicles of Narnia: The Lion, the Witch and the Wardrobe', 18, 1950, 'Fantasy', 8, 4.8, 'Children discover a magical world.'),
('The Raven', 19, 1845, 'Poetry', 10, 4.7, 'A haunting poem by Edgar Allan Poe.'),
('One Hundred Years of Solitude', 20, 1967, 'Magical Realism', 4, 4.9, 'A multigenerational tale of the Buendía family.');

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    membership_start_date DATE
);
-- insert query for users
-- Insert 20 users into the users table
INSERT INTO users (first_name, last_name, phone_number, email, membership_start_date) VALUES
('John', 'Doe', '123-456-7890', 'john.doe@example.com', '2023-01-01'),
('Jane', 'Smith', '123-456-7891', 'jane.smith@example.com', '2023-02-15'),
('Michael', 'Brown', '123-456-7892', 'michael.brown@example.com', '2023-03-10'),
('Emily', 'Johnson', '123-456-7893', 'emily.johnson@example.com', '2023-04-20'),
('Chris', 'Williams', '123-456-7894', 'chris.williams@example.com', '2023-05-05'),
('Sarah', 'Jones', '123-456-7895', 'sarah.jones@example.com', '2023-06-25'),
('David', 'Miller', '123-456-7896', 'david.miller@example.com', '2023-07-15'),
('Sophia', 'Davis', '123-456-7897', 'sophia.davis@example.com', '2023-08-10'),
('James', 'Garcia', '123-456-7898', 'james.garcia@example.com', '2023-09-01'),
('Olivia', 'Martinez', '123-456-7899', 'olivia.martinez@example.com', '2023-10-10'),
('Liam', 'Hernandez', '321-456-7890', 'liam.hernandez@example.com', '2023-11-05'),
('Isabella', 'Lopez', '321-456-7891', 'isabella.lopez@example.com', '2023-12-01'),
('Ethan', 'Gonzalez', '321-456-7892', 'ethan.gonzalez@example.com', '2023-12-15'),
('Ava', 'Wilson', '321-456-7893', 'ava.wilson@example.com', '2024-01-10'),
('Noah', 'Anderson', '321-456-7894', 'noah.anderson@example.com', '2024-02-05'),
('Mia', 'Thomas', '321-456-7895', 'mia.thomas@example.com', '2024-03-20'),
('Lucas', 'Taylor', '321-456-7896', 'lucas.taylor@example.com', '2024-04-01'),
('Amelia', 'Moore', '321-456-7897', 'amelia.moore@example.com', '2024-05-18'),
('Alexander', 'Jackson', '321-456-7898', 'alexander.jackson@example.com', '2024-06-10'),
('Charlotte', 'White', '321-456-7899', 'charlotte.white@example.com', '2024-07-01');
SELECT * FROM users;

-- Borrowings Table
CREATE TABLE borrowings (
    borrowing_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    book_id INT,
    borrow_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Insert 10 borrowings into the borrowings table
INSERT INTO borrowings (user_id, book_id, borrow_date, due_date, return_date) VALUES
(1, 1, '2025-01-01', '2025-01-10', NULL),
(2, 2, '2025-01-02', '2025-01-11', '2025-01-10'),
(3, 3, '2025-01-03', '2025-01-12', NULL),
(4, 4, '2025-01-04', '2025-01-13', NULL),
(5, 5, '2025-01-05', '2025-01-14', '2025-01-13'),
(6, 6, '2025-01-06', '2025-01-15', NULL),
(7, 7, '2025-01-07', '2025-01-16', NULL),
(8, 8, '2025-01-08', '2025-01-17', '2025-01-16'),
(9, 9, '2025-01-09', '2025-01-18', NULL),
(10, 10, '2025-01-10', '2025-01-19', NULL);

-- Queries:

-- 1. User-wise recommendation system: Recommend books not yet borrowed by the user.
SELECT b.title, b.genre
FROM books b
WHERE b.book_id NOT IN (
    SELECT br.book_id
    FROM borrowings br
    WHERE br.user_id = 1
)
LIMIT 5;

-- 2. User ID-wise genres (currently borrowed or not).
SELECT DISTINCT b.genre
FROM borrowings br
JOIN books b ON br.book_id = b.book_id
WHERE br.user_id = 1;

-- 3. Borrowing history (user-wise and book name-wise).
-- (a) User-wise borrowing history
SELECT u.first_name, u.last_name, b.title, br.borrow_date, br.due_date, br.return_date
FROM borrowings br
JOIN users u ON br.user_id = u.user_id
JOIN books b ON br.book_id = b.book_id;

-- (b) Book name-wise borrowing history
SELECT b.title, u.first_name, u.last_name, br.borrow_date, br.due_date, br.return_date
FROM borrowings br
JOIN books b ON br.book_id = b.book_id
JOIN users u ON br.user_id = u.user_id
ORDER BY b.title;

-- 4. Due dates for borrowed books.
SELECT b.title, br.due_date
FROM borrowings br
JOIN books b ON br.book_id = b.book_id
WHERE br.return_date IS NULL;

-- logic for due date details 
SELECT 
    br.borrowing_id,
    br.user_id,
    br.book_id,
    br.borrow_date,
    br.due_date,
    DATEDIFF(CURDATE(), br.due_date) AS days_overdue
FROM borrowings br
WHERE br.due_date < CURDATE() AND br.return_date IS NULL;

-- 5. Author popularity based on book ratings.
SELECT a.first_name, a.last_name, AVG(b.rating) AS average_rating
FROM books b
JOIN authors a ON b.author_id = a.author_id
GROUP BY a.author_id
ORDER BY average_rating DESC;

-- 6. Summary of books of authors based on book names.
SELECT b.title, b.summary
FROM books b
WHERE b.author_id = 1; -- Replace with the desired author ID.

-- 7 . total available in library
SELECT 
    SUM(available_copies) AS total_books 
FROM books;

-- 8. Issued Books
SELECT 
    COUNT(*) AS total_issued_books
FROM borrowings
WHERE return_date IS NULL;

-- 9.  
SELECT 
    (SELECT SUM(available_copies) FROM books) AS total_books,
    (SELECT COUNT(*) FROM borrowings WHERE return_date IS NULL) AS issued_books,
    (SELECT SUM(available_copies) FROM books) - 
    (SELECT COUNT(*) FROM borrowings WHERE return_date IS NULL) AS currently_available_books;
