

SELECT
    'At-Risk Students' AS Student_Group,
    COUNT(Student_Key) AS Total_At_Risk_Students,
    SUM(CASE WHEN Is_first_year_retained = 'Y' THEN 1 ELSE 0 END) AS Successfully_Retained,
    CAST(
        (SUM(CASE WHEN Is_first_year_retained = 'Y' THEN 1.0 ELSE 0.0 END) / COUNT(Student_Key)) * 100 
    AS DECIMAL(5,2)) AS Intervention_Success_Rate_Percent
FROM
    Dim_Student
WHERE
    Is_At_Risk_Flag = 'Y';


SELECT
    Housing_Status,
    COUNT(Student_Key) AS Total_Students,
    SUM(CASE WHEN Is_first_year_retained = 'Y' THEN 1 ELSE 0 END) AS Retained_Count,
    CAST(
        (SUM(CASE WHEN Is_first_year_retained = 'Y' THEN 1.0 ELSE 0.0 END) / COUNT(Student_Key)) * 100 
    AS DECIMAL(5,2)) AS Retention_Rate_Percent
FROM
    Dim_Student
GROUP BY
    Housing_Status
ORDER BY
    Retention_Rate_Percent DESC;


SELECT TOP 10
    c.Course_Name,
    c.Course_ID_Source,
    COUNT(f.Academic_Performance_Key) AS Total_Enrollments,
    SUM(CASE WHEN f.Is_Pass_Flag = 'N' THEN 1 ELSE 0 END) AS DFW_Count,
    CAST(
        (SUM(CASE WHEN f.Is_Pass_Flag = 'N' THEN 1.0 ELSE 0.0 END) / COUNT(f.Academic_Performance_Key)) * 100 
    AS DECIMAL(5,2)) AS DFW_Rate_Percent
FROM
    Fact_AcademicPerformance AS f
JOIN
    Dim_Course AS c ON f.Course_Key = c.Course_Key
GROUP BY
    c.Course_Name, c.Course_ID_Source
ORDER BY
    DFW_Rate_Percent DESC;


SELECT
    CASE 
        WHEN s.Is_first_year_retained = 'Y' THEN 'Retained' 
        ELSE 'Not Retained (Left)' 
    END AS Retention_Status,
    COUNT(DISTINCT s.Student_Key) AS Student_Count,
    CAST(AVG(f.Final_Grade_Numeric) AS DECIMAL(4,2)) AS Average_GPA
FROM
    Fact_AcademicPerformance AS f
JOIN
    Dim_Student AS s ON f.Student_Key = s.Student_Key
GROUP BY
    s.Is_first_year_retained;


SELECT
    'Non-Returning Students' AS Group_Name,
    COUNT(Student_Key) AS Total_Dropouts,
    SUM(CASE WHEN Academic_Standing = 'Probation' THEN 1 ELSE 0 END) AS Dropouts_On_Probation,
    CAST(
        (SUM(CASE WHEN Academic_Standing = 'Probation' THEN 1.0 ELSE 0.0 END) / COUNT(Student_Key)) * 100 
    AS DECIMAL(5,2)) AS Percent_On_Probation
FROM
    Dim_Student
WHERE
    Is_first_year_retained = 'N';