


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










