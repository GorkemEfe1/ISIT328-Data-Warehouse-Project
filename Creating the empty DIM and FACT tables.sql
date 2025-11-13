CREATE TABLE DIM_DEPARTMENT (
    Department_Key INT PRIMARY KEY IDENTITY(1,1),
    Department_ID_Source VARCHAR(50) NOT NULL, 
    Department_Name VARCHAR(100) NOT NULL,
    Dean_Name VARCHAR(100) NOT NULL,
    College_Name VARCHAR(100) NOT NULL
);
CREATE TABLE Dim_Semester (
	Semester_Key INT PRIMARY KEY IDENTITY(1,1),
    Semester_ID_Source VARCHAR(50) NOT NULL,
    Semester_Year VARCHAR(9) NOT NULL,
    Semester_Name VARCHAR(20) NOT NULL
 );
CREATE TABLE Dim_Professor (
 	Professor_Key INT PRIMARY KEY IDENTITY(1,1),
    Professor_ID_Source VARCHAR(50) NOT NULL,
    Professor_First_Name VARCHAR(100) NOT NULL,
    Professor_Last_Name VARCHAR(100) NOT NULL,
    Department_Key INT FOREIGN KEY REFERENCES Dim_Department(Department_Key)    
);
CREATE TABLE DIM_Course (
    Course_Key INT PRIMARY KEY IDENTITY(1,1),
    Department_Key INT FOREIGN KEY REFERENCES Dim_Department(Department_Key),
    Course_ID_Source VARCHAR(50) NOT NULL,
    Course_Name VARCHAR(50) NOT NULL,
    Course_Credit INT NOT NULL,
    Course_Level INT NULL,
    Is_Gateway_Course_Flag CHAR(1) NOT NULL DEFAULT 'N'
);
CREATE TABLE Dim_Student (
    Student_Key INT PRIMARY KEY IDENTITY(1,1),
    Major_Department_Key INT FOREIGN KEY REFERENCES Dim_Department(Department_Key),
    Student_ID_Source VARCHAR(50) NOT NULL, 
    Last_Name VARCHAR(100) NOT NULL,
    First_Name VARCHAR(100) NOT NULL,
    Birth_Date DATE NULL,  
    Home_State VARCHAR(50) NULL,
    Enrollment_Date DATE NULL,
    Financial_Aid_Status VARCHAR(50) NOT NULL, 
    Academic_Standing VARCHAR(50) NOT NULL,    
    Housing_Status VARCHAR(20) NOT NULL,       
    Is_At_Risk_Flag CHAR(1) NOT NULL DEFAULT 'N', 
    Is_first_year_retained char(1) Not null Default 'N'
);
CREATE TABLE Fact_AcademicPerformance (
    Academic_Performance_Key INT PRIMARY KEY IDENTITY(1,1),
    Student_Key INT FOREIGN KEY REFERENCES Dim_Student(Student_Key),
    Course_Key INT FOREIGN KEY REFERENCES Dim_Course(Course_Key),
    Professor_Key INT FOREIGN KEY REFERENCES Dim_Professor(Professor_Key),
    Semester_Key INT FOREIGN KEY REFERENCES Dim_Semester(Semester_Key),
    Final_Grade_Numeric DECIMAL(4,2) NOT NULL, 
    Credits_Attempted INT NOT NULL,
    Credits_Earned INT NOT NULL,
    Is_Pass_Flag CHAR(1) NOT NULL,     
    Is_Withdraw_Flag CHAR(1) NOT NULL  
);
/* Staging Tables - Just buckets for raw CSV data */

CREATE TABLE Staging_Departments (
    Department_ID_Source VARCHAR(50),
    Department_Name VARCHAR(100),
    College_Name VARCHAR(100),
    Dean_Name VARCHAR(100)
);

CREATE TABLE Staging_Students (
    Student_ID_Source VARCHAR(50),
    Major_Department_ID_Source VARCHAR(50),
    Last_Name VARCHAR(100),
    First_Name VARCHAR(100),
    Birth_Date VARCHAR(50), /* Load as string first to avoid date format errors */
    Home_State VARCHAR(50),
    Enrollment_Date VARCHAR(50),
    Financial_Aid_Status VARCHAR(50),
    Academic_Standing VARCHAR(50),
    Housing_Status VARCHAR(50)
);

CREATE TABLE Staging_Courses (
    Course_ID_Source VARCHAR(50),
    Department_ID_Source VARCHAR(50),
    Course_Name VARCHAR(100),
    Course_Credit VARCHAR(10),
    Course_Level VARCHAR(10),
    Is_Gateway_Course_Flag VARCHAR(10)
);

CREATE TABLE Staging_Professors (
    Professor_ID_Source VARCHAR(50),
    Professor_First_Name VARCHAR(100),
    Professor_Last_Name VARCHAR(100),
    Department_ID_Source VARCHAR(50)
);

CREATE TABLE Staging_Semesters (
    Semester_ID_Source VARCHAR(50),
    Semester_Year VARCHAR(50),
    Semester_Name VARCHAR(50)
);

CREATE TABLE Staging_Enrollments (
    Student_ID_Source VARCHAR(50),
    Course_ID_Source VARCHAR(50),
    Professor_ID_Source VARCHAR(50),
    Semester_ID_Source VARCHAR(50),
    Letter_Grade VARCHAR(10)
);