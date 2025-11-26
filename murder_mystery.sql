-- DROP TABLES if exist
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS keycard_logs CASCADE;
DROP TABLE IF EXISTS calls CASCADE;
DROP TABLE IF EXISTS alibis CASCADE;
DROP TABLE IF EXISTS evidence CASCADE;

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    role VARCHAR(50)
);

INSERT INTO employees VALUES
(1, 'Alice Johnson', 'Engineering', 'Software Engineer'),
(2, 'Bob Smith', 'HR', 'HR Manager'),
(3, 'Clara Lee', 'Finance', 'Accountant'),
(4, 'David Kumar', 'Engineering', 'DevOps Engineer'),
(5, 'Eva Brown', 'Marketing', 'Marketing Lead'),
(6, 'Frank Li', 'Engineering', 'QA Engineer'),
(7, 'Grace Tan', 'Finance', 'CFO'),
(8, 'Henry Wu', 'Engineering', 'CTO'),
(9, 'Isla Patel', 'Support', 'Customer Support'),
(10, 'Jack Chen', 'HR', 'Recruiter');

-- Keycard Logs Table
CREATE TABLE keycard_logs (
    log_id INT PRIMARY KEY,
    employee_id INT,
    room VARCHAR(50),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP
);

INSERT INTO keycard_logs VALUES
(1, 1, 'Office', '2025-10-15 08:00', '2025-10-15 12:00'),
(2, 2, 'HR Office', '2025-10-15 08:30', '2025-10-15 17:00'),
(3, 3, 'Finance Office', '2025-10-15 09:00', '2025-10-15 12:30'),
(4, 6, 'Server Room', '2025-10-15 08:00', '2025-10-15 09:10'),
(5, 5, 'Marketing Office', '2025-10-15 09:10', '2025-10-15 12:00'),
(6, 3, 'Office', '2025-10-15 20:30', '2025-10-15 21:30'),
(7, 7, 'Finance Office', '2025-10-15 19:00', '2025-10-15 21:00'),
(8, 6, 'Server Room', '2025-10-15 20:40', '2025-10-15 20:55'),
(9, 8, 'CEO Office', '2025-10-15 20:45', '2025-10-15 21:05'),
(10, 5, 'Office', '2025-10-15 20:30', '2025-10-15 21:10'),
(11, 4, 'CEO Office', '2025-10-15 20:50', '2025-10-15 21:00');

-- Calls Table
CREATE TABLE calls (
    call_id INT PRIMARY KEY,
    caller_id INT,
    receiver_id INT,
    call_time TIMESTAMP,
    duration_sec INT
);

INSERT INTO calls VALUES
(1, 9, 3, '2025-10-15 20:40', 45),
(2, 10, 1, '2025-10-15 20:48', 120),
(3, 4, 8, '2025-10-15 20:55', 30),
(4, 7, 5, '2025-10-15 21:30', 60);

-- Alibis Table
CREATE TABLE alibis (
    alibi_id INT PRIMARY KEY,
    employee_id INT,
    claimed_location VARCHAR(50),
    claim_time TIMESTAMP
);

INSERT INTO alibis VALUES
(1, 4, 'Home', '2025-10-15 21:00'),
(2, 6, 'Server Room', '2025-10-15 20:50'),
(3, 3, 'Finance Office', '2025-10-15 21:00'),
(4, 9, 'Cafeteria', '2025-10-15 20:40');

-- Evidence Table
CREATE TABLE evidence (
    evidence_id INT PRIMARY KEY,
    room VARCHAR(50),
    description VARCHAR(100),
    found_time TIMESTAMP
);

INSERT INTO evidence VALUES
(1, 'CEO Office', 'Bloody glove', '2025-10-15 21:05'),
(2, 'CEO Office', 'Footprint size 10', '2025-10-15 21:05'),
(3, 'Hallway', 'Broken keycard', '2025-10-15 21:10');


-------------------------------------------------------------------------------------

SELECT * FROM employees;


-------------------------------------------------
--– Find where and roughly when the crime happened?

SELECT
    room,
    MIN(found_time) AS first_evidence_time
FROM evidence
GROUP BY room
ORDER BY first_evidence_time;

-- Find who accessed the CEO Office around the crime time?

--We now look at keycard logs between
-- 20:50 and 21:10 on 2025-10-15

SELECT
    k.employee_id,
    e.name,
    k.room,
    k.entry_time,
    k.exit_time
FROM keycard_logs k
JOIN employees e
    ON k.employee_id = e.employee_id
WHERE k.room = 'CEO Office'
  AND k.entry_time BETWEEN '2025-10-15 20:50' AND '2025-10-15 21:10'
ORDER BY k.entry_time;

--Check if those people had suspicious or lying alibis?

--You now take the employees from Step 2
--(the ones who were in the CEO Office around 21:00)
--and check whether their alibis match or contradict the keycard logs.

SELECT
    a.employee_id,
    e.name,
    a.claimed_location,
    a.claim_time,
    k.room AS actual_room,
    k.entry_time AS actual_entry,
    k.exit_time AS actual_exit
FROM alibis a
JOIN employees e
    ON a.employee_id = e.employee_id
LEFT JOIN keycard_logs k
    ON a.employee_id = k.employee_id
    AND k.entry_time <= a.claim_time
    AND k.exit_time >= a.claim_time
WHERE a.employee_id IN (4, 8);

--Find calls around 20:50–21:00
SELECT
    c.call_id,
    e1.name  AS caller,
    e2.name  AS receiver,
    c.call_time,
    c.duration_sec
FROM calls c
JOIN employees e1 ON c.caller_id = e1.employee_id
JOIN employees e2 ON c.receiver_id = e2.employee_id
WHERE c.call_time BETWEEN '2025-10-15 20:50' AND '2025-10-15 21:00'
ORDER BY c.call_time;

--Final Step — “Case Solved” SQL query

SELECT name AS killer
FROM employees
WHERE employee_id = 4;


--If you want a more “logical” final query:

SELECT e.name AS killer
FROM employees e
JOIN keycard_logs k ON e.employee_id = k.employee_id
JOIN alibis a ON e.employee_id = a.employee_id
WHERE k.room = 'CEO Office'
  AND k.entry_time <= '2025-10-15 21:00'
  AND k.exit_time >= '2025-10-15 21:00'
  AND a.claimed_location <> 'CEO Office';




