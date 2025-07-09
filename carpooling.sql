CREATE DATABASE carpooling;
USE carpooling;

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

INSERT INTO users (id, name, role, email, password) VALUES
(1, 'Arun', 'driver', 'arun@example.com', 'pass123'),
(2, 'Sneha', 'passenger', 'sneha@example.com', 'pass456'),
(3, 'Ravi', 'driver', 'ravi@example.com', 'pass789'),
(4, 'Priya', 'passenger', 'priya@example.com', 'passabc'),
(5, 'Manoj', 'passenger', 'manoj@example.com', 'passxyz');

CREATE TABLE rides (
    ride_id INT PRIMARY KEY,
    driver_id INT NOT NULL,
    origin VARCHAR(255) NOT NULL,
    destination VARCHAR(255) NOT NULL,
    departure DATETIME NOT NULL,
    seats INT NOT NULL CHECK (seats >= 0),
    FOREIGN KEY (driver_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO rides (ride_id, driver_id, origin, destination, departure, seats) VALUES
(1, 1, 'Chennai', 'Bangalore', '2025-03-01 08:00:00', 3),
(2, 3, 'Hyderabad', 'Vijayawada', '2025-03-02 09:30:00', 2),
(3, 1, 'Coimbatore', 'Madurai', '2025-03-03 12:00:00', 4),
(4, 3, 'Kochi', 'Thiruvananthapuram', '2025-03-04 14:15:00', 1),
(5, 1, 'Mysore', 'Mangalore', '2025-03-05 16:45:00', 5);


CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    ride_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Confirmed', 'Cancelled', 'Pending')),
    FOREIGN KEY (ride_id) REFERENCES rides(ride_id) ON DELETE CASCADE,
    FOREIGN KEY (passenger_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO bookings (booking_id, ride_id, passenger_id, booking_time, status) VALUES
(1, 1, 2, '2025-02-20 10:00:00', 'Confirmed'),
(2, 1, 4, '2025-02-21 11:30:00', 'Pending'),
(3, 2, 5, '2025-02-22 12:45:00', 'Confirmed'),
(4, 4, 2, '2025-02-23 14:00:00', 'Cancelled'),
(5, 5, 4, '2025-02-24 15:15:00', 'Confirmed');

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

INSERT INTO payments (payment_id, booking_id, amount, payment_time) VALUES
(1, 1, 500.00, '2025-02-20 10:30:00'),
(2, 3, 750.00, '2025-02-22 13:00:00'),
(3, 5, 600.00, '2025-02-24 15:45:00'),
(4, 1, 450.00, '2025-02-20 10:35:00');


SELECT * FROM users;
SELECT * FROM rides;
SELECT * FROM bookings;
SELECT * FROM payments;

