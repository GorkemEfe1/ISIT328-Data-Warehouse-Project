
SELECT
    s.Academic_Standing,
    AVG(f.Final_Grade_Numeric) AS Average_GPA,
    COUNT(DISTINCT s.Student_Key) AS Total_Students
FROM
    Fact_AcademicPerformance AS f
JOIN
    Dim_Student AS s ON f.Student_Key = s.Student_Key
WHERE

    s.Is_At_Risk_Flag = 'Y'
    AND
    s.Is_first_year_retained = 'N'
GROUP BY
    s.Academic_Standing;