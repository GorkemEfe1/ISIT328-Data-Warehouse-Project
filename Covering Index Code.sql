PRINT 'Creating Covering Indexes...';


CREATE INDEX idx_student_COVERING
ON Dim_Student (Is_At_Risk_Flag, Is_first_year_retained)
INCLUDE (Academic_Standing);

CREATE INDEX idx_fact_COVERING
ON Fact_AcademicPerformance (Student_Key)
INCLUDE (Final_Grade_Numeric);


PRINT 'Covering indexes created successfully.';
