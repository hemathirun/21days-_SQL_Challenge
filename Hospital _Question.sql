


--DAY 1 Challengs 


--Question: List all unique hospital services available in the hospital?

SELECT DISTINCT service
FROM services_weekly
order by service;

--Daily Challenge DAY 2

--Question : 
--Find all patients admitted to 'Surgery' service with a satisfaction score below 70?
SELECT 
    patient_id,
    name,
    age,
    satisfaction AS satisfaction_score
FROM patients
WHERE service = 'surgery'
  AND satisfaction < 70;

----Daily Challenge DAY 3

--Retrieve the top 5 weeks with the highest patient refusals across all services?
SELECT 
    week,
    service,
    patients_refused,
    patients_request
FROM services_weekly
ORDER BY patients_refused DESC
LIMIT 5;

----Daily Challenge DAY 4

--Find the 3rd to 7th highest patient satisfaction scores, showing patient_id, name, 
--service, and satisfaction?

select patient_id,
       name,
	   service,
	   satisfaction
from patients
order by satisfaction DESC
LIMIT 5 OFFSET 2;

--Daily Challenge DAY 5

--Calculate the total number of patients admitted, total patients refused, 
--and average patient satisfaction across all services and weeks. Round the 
--average to 2 decimals?

SELECT 
    SUM(patients_admitted) AS total_admitted,
    SUM(patients_refused) AS total_refused,
    ROUND(AVG(patient_satisfaction), 2) AS avg_satisfaction
FROM services_weekly;

--Daily Challenge DAY 6

--For each hospital service, calculate:
--Total patients admitted
--Total patients refused
--Admission rate = admitted / requests * 100%
--Order by admission rate descending

SELECT
    service,
    SUM(patients_admitted) AS total_admitted,
    SUM(patients_refused) AS total_refused,
    ROUND(
        (SUM(patients_admitted) * 100.0 / SUM(patients_request)), 
        2
    ) AS admission_rate_percent
FROM services_weekly
GROUP BY service
ORDER BY admission_rate_percent DESC;

----Daily Challenge DAY 7

--Identify services that refused more than 100 patients 
--in total AND had average satisfaction below 80?

SELECT
    service,
    SUM(patients_refused) AS total_refused,
    AVG(patient_satisfaction) AS avg_satisfaction
FROM services_weekly
GROUP BY service
HAVING 
    SUM(patients_refused) > 100
    AND AVG(patient_satisfaction) < 80;

--Daily Challenge Day 8 

--Question:** Create a patient summary that shows patient_id, full name in uppercase, 
--service in lowercase, age category (if age >= 65 then 'Senior', if age >= 18 then 
--'Adult', else 'Minor'), and name length. Only show patients whose name length 
--is greater than 10 characters?

SELECT
    patient_id,
    UPPER(name) AS full_name_uppercase,
    LOWER(service) AS service_lowercase,
    
    CASE 
        WHEN age >= 65 THEN 'Senior'
        WHEN age >= 18 THEN 'Adult'
        ELSE 'Minor'
    END AS age_category,
    
    LENGTH(name) AS name_length

FROM patients
WHERE LENGTH(name) > 10;

--Daily Challenge Day 10

--Question: Create a service performance report showing service name, 
--total patients admitted, and a performance category based on the following: 
--'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' if >= 65,
--otherwise 'Needs Improvement'. Order by average satisfaction descending.

SELECT
    service,
    SUM(patients_admitted) AS total_admitted,
    AVG(patient_satisfaction) AS avg_satisfaction,

    CASE
        WHEN AVG(patient_satisfaction) >= 85 THEN 'Excellent'
        WHEN AVG(patient_satisfaction) >= 75 THEN 'Good'
        WHEN AVG(patient_satisfaction) >= 65 THEN 'Fair'
        ELSE 'Needs Improvement'
    END AS performance_category

FROM services_weekly
GROUP BY service
ORDER BY avg_satisfaction DESC;

--Daily Challenge Day 11
--Question: Find all unique combinations of service and event type from the services_weekly 
--table where events are not null or none, along with the count of occurrences for 
--each combination. Order by count descending?

SELECT
    service,
    event,
    COUNT(*) AS total_occurrences
FROM services_weekly
WHERE event IS NOT NULL
  AND event <> 'none'
GROUP BY service, event
ORDER BY total_occurrences DESC;

--Daily Challenge Day 12
--Question: Analyze the event impact by comparing weeks with events vs weeks without events. 
--Show: event status ('With Event' or 'No Event'), count of weeks, average patient 
--satisfaction, and average staff morale. Order by average patient satisfaction descending?

SELECT
    CASE
        WHEN event IS NOT NULL
             AND event <> ''
             AND event <> 'none'
        THEN 'With Event'
        ELSE 'No Event'
    END AS event_status,
    
    COUNT(DISTINCT week) AS week_count,
    AVG(patient_satisfaction) AS avg_patient_satisfaction,
    AVG(staff_morale) AS avg_staff_morale
FROM services_weekly
GROUP BY event_status
ORDER BY avg_patient_satisfaction DESC;

----Daily Challenge Day 13

--Question: Create a comprehensive report showing patient_id, patient name, age, 
--service, and the total number of staff members available in their service. 
--Only include patients from services that have more than 5 staff members.
--Order by number of staff descending, then by patient name.

-- Step 1: Count staff by service

WITH staff_count AS (
    SELECT 
        service,
        COUNT(*) AS total_staff
    FROM staff
    GROUP BY service
)
-- Step 2: Join with patients and filter
SELECT 
    p.patient_id,
    p.name AS patient_name,
    p.age,
    p.service,
    sc.total_staff
FROM patients p
INNER JOIN staff_count sc
    ON p.service = sc.service
WHERE sc.total_staff > 5
ORDER BY sc.total_staff DESC, p.name ASC;








