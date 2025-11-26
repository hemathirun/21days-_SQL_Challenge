


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

----Daily Challenge Day 14

--Question: Create a staff utilisation report showing all staff members 
--(staff_id, staff_name, role, service) and the count of weeks they were
--present (from staff_schedule). Include staff members even 
--if they have no schedule records. Order by weeks present descending.

SELECT
    s.staff_id,
    s.staff_name,
    s.role,
    s.service,
    COALESCE(
        SUM(
            CASE 
                WHEN ss.present = 1 THEN 1 
                ELSE 0 
            END
        ), 
        0
    ) AS weeks_present
FROM staff s
LEFT JOIN staff_schedule ss
    ON s.staff_id = ss.staff_id
GROUP BY
    s.staff_id,
    s.staff_name,
    s.role,
    s.service
ORDER BY
    weeks_present DESC,
    s.staff_name;

----Daily Challenge Day 15
--Comprehensive service analysis for week 20:
--service name,
--total patients admitted that week,
--total patients refused,
--average patient satisfaction,
--count of staff assigned to service,
--count of staff present that week.
--Order by patients admitted descending.


-- Count staff per service
WITH staff_assigned AS (
    SELECT
        service,
        COUNT(*) AS total_staff_assigned
    FROM staff
    GROUP BY service
),

-- Count staff present in week 20 per service
staff_present AS (
    SELECT
        s.service,
        COUNT(*) AS total_staff_present_week
    FROM staff_schedule ss
    JOIN staff s
        ON ss.staff_id = s.staff_id
    WHERE ss.week = 20
      AND ss.present = 1
    GROUP BY s.service
)

SELECT
    sw.service,
    SUM(sw.patients_admitted)      AS total_admitted,
    SUM(sw.patients_refused)       AS total_refused,
    AVG(sw.patient_satisfaction)   AS avg_patient_satisfaction,
    COALESCE(sa.total_staff_assigned, 0)      AS staff_assigned,
    COALESCE(sp.total_staff_present_week, 0)  AS staff_present_week
FROM services_weekly sw
LEFT JOIN staff_assigned sa
    ON sw.service = sa.service
LEFT JOIN staff_present sp
    ON sw.service = sp.service
WHERE sw.week = 20
GROUP BY
    sw.service,
    sa.total_staff_assigned,
    sp.total_staff_present_week
ORDER BY
    total_admitted DESC;
	

--Daily Challenge Day 16

--Find all patients who were admitted to services that had at least one week where 
--patients were refused AND the average patient satisfaction for that service was 
--below the overall hospital average satisfaction. Show patient_id, name, service, 
--and their personal satisfaction score.

SELECT
    p.patient_id,
    p.name,
    p.service,
    p.satisfaction AS personal_satisfaction
FROM patients p
WHERE p.service IN (
    SELECT sw.service
    FROM services_weekly sw
    GROUP BY sw.service
    HAVING
        SUM(CASE WHEN sw.patients_refused > 0 THEN 1 ELSE 0 END) > 0
        AND AVG(sw.patient_satisfaction) <
            (SELECT AVG(patient_satisfaction) FROM services_weekly)
)
ORDER BY p.service, p.patient_id;

---Daily Challenge Day 17

--Create a report showing each service with: service name, total patients admitted, 
--the difference between their total admissions and the average admissions across 
--all services, and a rank indicator ('Above Average', 'Average', 'Below Average').
--Order by total patients admitted descending.

WITH service_totals AS (
    SELECT
        service,
        SUM(patients_admitted) AS total_admitted
    FROM services_weekly
    GROUP BY service
),
overall_avg AS (
    SELECT AVG(total_admitted) AS avg_admitted
    FROM service_totals
)
SELECT
    st.service,
    st.total_admitted,
    st.total_admitted - oa.avg_admitted AS diff_from_avg,
    CASE
        WHEN st.total_admitted > oa.avg_admitted THEN 'Above Average'
        WHEN st.total_admitted = oa.avg_admitted THEN 'Average'
        ELSE 'Below Average'
    END AS rank_indicator
FROM service_totals st
CROSS JOIN overall_avg oa
ORDER BY st.total_admitted DESC;

--Daily Challenge Day 18

--Create a comprehensive personnel and patient list showing: identifier 
--(patient_id or staff_id), full name, type ('Patient' or 'Staff'), and 
--associated service. Include only those in 'surgery' or 'emergency' services. 
--Order by type, then service, then name.

SELECT
    patient_id AS identifier,
    name AS full_name,
    'Patient' AS type,
    service
FROM patients
WHERE LOWER(service) IN ('surgery', 'emergency')

UNION ALL

SELECT
    staff_id AS identifier,
    staff_name AS full_name,
    'Staff' AS type,
    service
FROM staff
WHERE LOWER(service) IN ('surgery', 'emergency')

ORDER BY type, service, full_name;


----Daily Challenge Day 19

--For each service, rank the weeks by patient satisfaction score (highest first). 
--Show service, week, patient_satisfaction, patients_admitted, and the rank. 
--Include only the top 3 weeks per service.

WITH satisfaction_rank AS (
    SELECT
        service,
        week,
        patient_satisfaction,
        patients_admitted,
        RANK() OVER (
            PARTITION BY service
            ORDER BY patient_satisfaction DESC
        ) AS sat_rank
    FROM services_weekly
)
SELECT
    service,
    week,
    patient_satisfaction,
    patients_admitted,
    sat_rank AS rank
FROM satisfaction_rank
WHERE sat_rank <= 3
ORDER BY service, rank, week;


