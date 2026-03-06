-- Dataset: Medical Appointment No Shows
-- Goal: Investigate factors influencing missed appointments

-- 1. SMS Reminder vs No-show rate
SELECT 
    SMS_received,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
    ROUND(
        SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS no_show_percent
FROM appointments
GROUP BY SMS_received;

-- 2. Appointment wait time distribution
SELECT 
    DATEDIFF(AppointmentDay, ScheduledDay) AS wait_days,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY wait_days
ORDER BY wait_days;

-- Investigating whether wait time influences missed appointments

-- 3. Wait time vs No-show rate
SELECT 
    DATEDIFF(AppointmentDay, ScheduledDay) AS wait_days,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
    ROUND(
        SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS no_show_percent
FROM appointments
WHERE DATEDIFF(AppointmentDay, ScheduledDay) >= 0
GROUP BY wait_days
ORDER BY wait_days;

--4. Wait time grouped into scheduling windows

SELECT 
CASE 
    WHEN DATEDIFF(AppointmentDay, ScheduledDay) = 0 THEN 'Same Day'
    WHEN DATEDIFF(AppointmentDay, ScheduledDay) BETWEEN 1 AND 3 THEN '1-3 Days'
    WHEN DATEDIFF(AppointmentDay, ScheduledDay) BETWEEN 4 AND 7 THEN '4-7 Days'
    WHEN DATEDIFF(AppointmentDay, ScheduledDay) BETWEEN 8 AND 14 THEN '8-14 Days'
    ELSE '15+ Days'
END AS wait_group,
COUNT(*) AS total,
SUM(CASE WHEN `No-show`='Yes' THEN 1 ELSE 0 END) AS missed
FROM appointments
WHERE DATEDIFF(AppointmentDay, ScheduledDay) >= 0
GROUP BY wait_group;

-- 5. No-show rate by age
SELECT
    Age,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
    ROUND(
        SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS no_show_percent
FROM appointments
WHERE Age >= 0
GROUP BY Age
ORDER BY Age;

-- 6. No-show rate by day of week
SELECT
    DAYNAME(AppointmentDay) AS day_of_week,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
    ROUND(
        SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS no_show_percent
FROM appointments
GROUP BY day_of_week
ORDER BY FIELD(day_of_week,
    'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');
    
    -- 7. No-show rate by financial assistance (Scholarship)
SELECT
    Scholarship,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
    ROUND(
        SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS no_show_percent
FROM appointments
GROUP BY Scholarship;

-- 8. No-show rate by gender
SELECT
    Gender,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
    ROUND(
        SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS no_show_percent
FROM appointments
GROUP BY Gender;

-- 9. No-show rate by neighborhood
SELECT
    Neighbourhood,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
    ROUND(
        SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS no_show_percent
FROM appointments
GROUP BY Neighbourhood
ORDER BY no_show_percent DESC
LIMIT 10;

-- 12. No-show rate by age group
SELECT
CASE
    WHEN Age BETWEEN 0 AND 17 THEN '0-17'
    WHEN Age BETWEEN 18 AND 29 THEN '18-29'
    WHEN Age BETWEEN 30 AND 44 THEN '30-44'
    WHEN Age BETWEEN 45 AND 59 THEN '45-59'
    WHEN Age BETWEEN 60 AND 74 THEN '60-74'
    ELSE '75+'
END AS age_group,
COUNT(*) AS total_appointments,
SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) AS missed,
ROUND(
    SUM(CASE WHEN `No-show` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
) AS no_show_percent
FROM appointments
WHERE Age >= 0
GROUP BY age_group
ORDER BY FIELD(age_group,
'0-17','18-29','30-44','45-59','60-74','75+');