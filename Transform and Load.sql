
INSERT INTO Dim_Department (
    Department_ID_Source,
    Department_Name,
    Dean_Name,
    College_Name
)
SELECT
    Department_ID_Source,
    Department_Name,
    Dean_Name,
    College_Name
FROM
    Staging_Departments;


INSERT INTO Dim_Professor (
    Professor_ID_Source,
    Professor_First_Name,
    Professor_Last_Name,
    Department_Key 
)
SELECT
    s.Professor_Source_ID,
    s.First_Name,
    s.Last_Name,
    d.Department_Key  
FROM
    Staging_Professors AS s
JOIN
    Dim_Department AS d ON s.Department_ID_Source = d.Department_ID_Source;


INSERT INTO Dim_Course (
    Department_Key, 
    Course_ID_Source,
    Course_Name,
    Course_Credit,
    Course_Level,
    Is_Gateway_Course_Flag
)
SELECT
    d.Department_Key,
    s.Course_ID_Source,
    s.Course_Name,
    CONVERT(INT, s.Course_Credit), 
    CONVERT(INT, s.Course_Level),  
    s.Is_Gateway_Course_Flag
FROM
    Staging_Courses AS s
JOIN
    Dim_Department AS d ON s.Department_ID_Source = d.Department_ID_Source;


INSERT INTO Dim_Semester (
    Semester_ID_Source,
    Semester_Year,
    Semester_Name
)
SELECT
    Semester_ID_Source,
    Semester_Year,
    Semester_Name
FROM
    Staging_Semesters;


INSERT INTO Dim_Student (
    Major_Department_Key, 
    Student_ID_Source,
    Last_Name,
    First_Name,
    Birth_Date,
    Home_State,
    Enrollment_Date,
    Financial_Aid_Status,
    Academic_Standing,
    Housing_Status
)
SELECT
    d.Department_Key,
    s.Student_ID_Source,
    s.Last_Name,
    s.First_Name,
    CONVERT(DATE, s.Birth_Date),       
    s.Home_State,
    CONVERT(DATE, s.Enrollment_Date),  
    s.Financial_Aid_Status,
    s.Academic_Standing,
    s.Housing_Status
FROM
    Staging_Students AS s
LEFT JOIN 
    Dim_Department AS d ON s.Major_Department_ID_Source = d.Department_ID_Source;


INSERT INTO Fact_AcademicPerformance (
    Student_Key,
    Course_Key,
    Professor_Key,
    Semester_Key,
    Final_Grade_Numeric,
    Credits_Attempted,
    Credits_Earned,
    Is_Pass_Flag,
    Is_Withdraw_Flag
)
SELECT
    
    ds.Student_Key,
    dc.Course_Key,
    dp.Professor_Key,
    dsem.Semester_Key,

    
    
    CASE sg.Letter_Grade
        WHEN 'A' THEN 4.0
        WHEN 'A-' THEN 3.7
        WHEN 'B+' THEN 3.3
        WHEN 'B' THEN 3.0
        WHEN 'B-' THEN 2.7
        WHEN 'C+' THEN 2.3
        WHEN 'C' THEN 2.0
        WHEN 'C-' THEN 1.7
        WHEN 'D' THEN 1.0
        ELSE 0.0
    END AS Final_Grade_Numeric,
    
    
    dc.Course_Credit AS Credits_Attempted,
    
    
    CASE 
        WHEN sg.Letter_Grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D') THEN dc.Course_Credit
        ELSE 0
    END AS Credits_Earned,
    
    CASE
        WHEN sg.Letter_Grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D') THEN 'Y'
        ELSE 'N'
    END AS Is_Pass_Flag,
    
    CASE
        WHEN sg.Letter_Grade = 'W' THEN 'Y'
        ELSE 'N'
    END AS Is_Withdraw_Flag

FROM
    Staging_Grades AS sg

JOIN Dim_Student AS ds ON sg.Student_ID_Source = ds.Student_ID_Source
JOIN Dim_Course AS dc ON sg.Course_ID_Source = dc.Course_ID_Source
JOIN Dim_Professor AS dp ON sg.Professor_ID_Source = dp.Professor_ID_Source
JOIN Dim_Semester AS dsem ON sg.Semester_ID_Source = dsem.Semester_ID_Source;






SELECT DISTINCT Student_Key
INTO #Year1Students
FROM Fact_AcademicPerformance f
JOIN Dim_Semester s ON f.Semester_Key = s.Semester_Key
WHERE s.Semester_Year = '2024-2025';


SELECT DISTINCT Student_Key
INTO #Year2Students
FROM Fact_AcademicPerformance f
JOIN Dim_Semester s ON f.Semester_Key = s.Semester_Key
WHERE s.Semester_Year = '2025-2026';

UPDATE Dim_Student
SET Is_first_year_retained = 'Y'
WHERE Student_Key IN (SELECT Student_Key FROM #Year1Students)
  AND Student_Key IN (SELECT Student_Key FROM #Year2Students);


UPDATE Dim_Student
SET Is_first_year_retained = 'N'
WHERE Student_Key IN (SELECT Student_Key FROM #Year1Students)
  AND Student_Key NOT IN (SELECT Student_Key FROM #Year2Students);


DROP TABLE #Year1Students;
DROP TABLE #Year2Students;




UPDATE Dim_Student
SET Is_At_Risk_Flag = 'Y'
WHERE

    Academic_Standing = 'Probation'
    
    OR (Housing_Status = 'Commuter' AND Financial_Aid_Status = 'No Aid');