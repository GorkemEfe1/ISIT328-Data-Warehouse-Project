/*
  This script creates "Covering Indexes".
  These are "super-indexes" that the query optimizer
  will be FORCED to use because they are so efficient.
*/
PRINT 'Creating Covering Indexes...';

/*
  This index "covers" the entire Dim_Student part of the query:
  1. It filters on the (KEY) fields: Is_At_Risk_Flag, Is_first_year_retained
  2. It includes the (DATA) fields: Academic_Standing
*/
CREATE INDEX idx_student_COVERING
ON Dim_Student (Is_At_Risk_Flag, Is_first_year_retained)
INCLUDE (Academic_Standing);

/*
  This index "covers" the entire Fact_AcademicPerformance part of the query:
  1. It filters on the (KEY) field: Student_Key (for the JOIN)
  2. It includes the (DATA) field: Final_Grade_Numeric (for the AVG)
*/
CREATE INDEX idx_fact_COVERING
ON Fact_AcademicPerformance (Student_Key)
INCLUDE (Final_Grade_Numeric);


PRINT 'Covering indexes created successfully.';