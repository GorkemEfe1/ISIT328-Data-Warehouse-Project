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
