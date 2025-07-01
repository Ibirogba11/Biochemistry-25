SELECT * FROM projects.biochemistry_data;

UPDATE biochemistry_data
SET fav_lecturer = CASE 
    WHEN fav_lecturer LIKE '%Prof%' OR fav_lecturer LIKE '%Dr.%' THEN fav_lecturer
    ELSE NULL
END;

UPDATE biochemistry_data
SET if_not_biochemistry = NULL
WHERE if_not_biochemistry = '';

UPDATE biochemistry_data
SET fav_course = NULL
WHERE fav_course = 'NIL';

SELECT state_of_origin 
FROM biochemistry_data
WHERE state_of_origin NOT LIKE '%State%';

SELECT CONCAT(state_of_origin, ' ', 'State')
FROM (
	SELECT state_of_origin 
FROM biochemistry_data
WHERE state_of_origin NOT LIKE '%State%'
) AS L1;

UPDATE biochemistry_data
SET state_of_origin = 'Osun State'
WHERE state_of_origin = 'Odun State';

UPDATE biochemistry_data
SET state_of_origin = 'Oyo State'
WHERE state_of_origin = 'Ibadan';


SELECT stressful_level
FROM biochemistry_data
WHERE stressful_level NOT LIKE '%Level%' AND stressful_level NOT LIKE '%All%';

UPDATE biochemistry_data
SET state_of_origin = CONCAT(state_of_origin, ' ', 'State')
WHERE state_of_origin NOT LIKE '%State%';


-- 1.	How many students are from each state of origin?
SELECT 	state_of_origin, 
		COUNT(student_id) AS `No`, 
		ROUND(COUNT(student_id) * 100.0/ (SELECT COUNT(*) FROM Biochemistry_data), 1) AS Percentage 
FROM biochemistry_data
GROUP BY state_of_origin;

SELECT 	l1.state_of_origin, l1.relationship_status, Counts,
		ROUND(l1.Counts * 100.0/ (SELECT COUNT(*) FROM Biochemistry_data), 1) AS Percentage, 
        ROW_NUMBER() OVER(PARTITION BY relationship_status) as Ranks
FROM biochemistry_data, (SELECT state_of_origin, relationship_status, COUNT(*) AS Counts
FROM biochemistry_data
GROUP BY state_of_origin, relationship_status) AS L1
GROUP BY l1.state_of_origin, l1.relationship_status;

SELECT fav_course, COUNT(fav_course) AS Counts
		FROM biochemistry_data
        GROUP BY fav_course
        ORDER BY Counts desc;
        
-- Which is the most favourite lectuere

SELECT fav_lecturer, COUNT(*) AS Counts
FROM biochemistry_data
GROUP BY fav_lecturer
ORDER BY Counts desc;

-- 7.	Which level (e.g., 100, 200, etc.) is rated as the most stressful?
SELECT stressful_level, COUNT(*) AS Counts
FROM biochemistry_data
GROUP BY stressful_level
ORDER BY Counts desc;

SELECT if_not_biochemistry, COUNT(*) AS Counts
FROM biochemistry_data
GROUP BY if_not_biochemistry
ORDER BY Counts desc;
SELECT * FROM
(SELECT 	state_of_origin, fav_lecturer, COUNT(*) AS Counts,
		row_number() OVER(partition by fav_lecturer order by COUNT(*) desc) AS Ranks
FROM biochemistry_data
WHERE fav_lecturer IS NOT NULL
GROUP BY state_of_origin, fav_lecturer
ORDER BY Counts desc) AS L1
HAVING Ranks = 1;

SELECT * FROM projects.biochemistry_data;


