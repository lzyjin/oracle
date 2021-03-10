-- 5. DML
-- 1)
INSERT INTO TB_CLASS_TYPE VALUES('01','전공필수');
INSERT INTO TB_CLASS_TYPE VALUES('02','전공선택');
INSERT INTO TB_CLASS_TYPE VALUES('03','교양필수');
INSERT INTO TB_CLASS_TYPE VALUES('04','교양선택');
INSERT INTO TB_CLASS_TYPE VALUES('05','논문지도');

-- 2)
CREATE TABLE TB_학생일반정보(학번, 학생이름, 주소)
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT;

SELECT * FROM TB_학생일반정보;

-- 3)
CREATE TABLE TB_국어국문학과(학번, 학생이름, 출생년도, 교수이름)
AS SELECT STUDENT_NO, STUDENT_NAME, TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 6)), 'YYYY/MM/DD'), NVL(PROFESSOR_NAME, '지도교수 없음')
   FROM TB_STUDENT S
        LEFT JOIN TB_PROFESSOR ON (PROFESSOR_NO = COACH_PROFESSOR_NO)
        LEFT JOIN TB_DEPARTMENT D ON(D.DEPARTMENT_NO = S.DEPARTMENT_NO)
   WHERE DEPARTMENT_NAME = '국어국문학과';

SELECT * FROM TB_국어국문학과;

-- 4)
UPDATE TB_DEPARTMENT
SET CAPACITY = ROUND(CAPACITY * 1.1);

-- 5)
UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042';

-- 6)
UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN, 1, 6);

-- 7)
SELECT STUDENT_NAME, DEPARTMENT_NAME, POINT, TERM_NO, CLASS_NAME
FROM TB_STUDENT
     JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
     JOIN TB_GRADE USING(STUDENT_NO)
     JOIN TB_CLASS USING(CLASS_NO)
WHERE STUDENT_NAME = '김명훈'
      AND DEPARTMENT_NAME = '의학과'
      AND TERM_NO LIKE '2005%'
      AND CLASS_NAME = '피부생리학'; -- 1.5

UPDATE TB_GRADE
SET POINT = 3.5
WHERE STUDENT_NO = (SELECT STUDENT_NO
                    FROM TB_STUDENT
                         JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
                    WHERE STUDENT_NAME = '김명훈'
                          AND DEPARTMENT_NAME = '의학과')
      AND TERM_NO LIKE '2005%'
      AND CLASS_NO = (SELECT CLASS_NO 
                      FROM TB_CLASS
                      WHERE CLASS_NAME = '피부생리학');

COMMIT;
-- 8)
DELETE FROM TB_GRADE
WHERE STUDENT_NO IN (SELECT STUDENT_NO
                    FROM TB_STUDENT
                    WHERE ABSENCE_YN = 'Y');