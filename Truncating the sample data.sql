
TRUNCATE TABLE Fact_AcademicPerformance;

DELETE FROM Dim_Student;
DELETE FROM Dim_Course;
DELETE FROM Dim_Professor;
DELETE FROM Dim_Semester;
DELETE FROM Dim_Department;

DBCC CHECKIDENT ('Dim_Student', RESEED, 0);
DBCC CHECKIDENT ('Dim_Course', RESEED, 0);
DBCC CHECKIDENT ('Dim_Professor', RESEED, 0);
DBCC CHECKIDENT ('Dim_Semester', RESEED, 0);
DBCC CHECKIDENT ('Dim_Department', RESEED, 0);