

-- SELECT문 종합 

--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오. 
SELECT EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_TITLE = '기술지원부');


--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오
SELECT EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_TITLE = '기술지원부') 
    AND SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID WHERE DEPT_TITLE = '기술지원부');

-- 테이블 확인용 
SELECT *
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
 WHERE DEPT_TITLE = (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_TITLE = '기술지원부');   
    
    
--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오. 
--1. JOIN을 이용하시오
SELECT E.EMP_ID AS 사번, E.EMP_NAME AS 사원명, M.EMP_NAME AS 매니저명, E.SALARY AS 월급
FROM EMPLOYEE E
    JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE) AND E.MANAGER_ID IS NOT NULL;


--2. JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기   
SELECT EMP_ID, EMP_NAME, (SELECT EMP_NAME FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL)
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE;

SELECT *
FROM DEPARTMENT;

--문제4
--같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회
SELECT EMP_NAME AS 사원명, JOB_CODE AS 직급, SALARY AS 급여, SAL_LEVEL AS 급여등급, FLOOR((SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.JOB_CODE = JOB_CODE)) AS "직급의 평균  급여"
FROM EMPLOYEE E
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.JOB_CODE = JOB_CODE)
ORDER BY JOB_CODE;


--문제5
--부서별 평균 급여가 2200000 이상인 부서명, 평균 급여 조회
--단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리
SELECT *
FROM (
    SELECT NVL(DEPT_TITLE, '인턴') AS 부서명, FLOOR(AVG(SALARY))AS "부서별 급여 평균"
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    GROUP BY DEPT_TITLE
)
WHERE "부서별 급여 평균" >= 2200000
ORDER BY 부서명 ASC;


--문제6
--직급의 연봉 평균보다 적게 받는 여자사원의
--사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오
--연봉 계산 => (급여+(급여*보너스))*12    
-- 사원명,직급명,부서명,연봉은 EMPLOYEE 테이블을 통해 출력이 가능함  

SELECT EMP_NAME AS 사원명, JOB_NAME AS 직급명, DEPT_TITLE AS 부서명, (SALARY+(SALARY*NVL(BONUS, 1)))*12 AS 연봉
FROM EMPLOYEE E
    JOIN DEPARTMENT ON DEPT_ID = E.DEPT_CODE
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') = '여'
    AND (SALARY + (SALARY *NVL(BONUS,1)))*12  < (SELECT AVG((SALARY + (SALARY *NVL(BONUS,1)))*12) FROM EMPLOYEE EP WHERE E.JOB_CODE = EP.JOB_CODE);
    --AND (SALARY+(SALARY*BONUS))*12 < (SELECT (AVG(SALARY+(SALARY*NVL(BONUS, 1)))*12) FROM EMPLOYEE GROUP BY JOB_CODE);


(SALARY + (SALARY *NVL(BONUS,1)))*12

