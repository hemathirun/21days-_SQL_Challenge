


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










