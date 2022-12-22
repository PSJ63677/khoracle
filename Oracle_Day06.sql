--# ROLLUP과 CUBE
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- 부서내 직급별 급여 합계
SELECT DEPT_COD, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;
-- CUBE: 부서내합계 + 직급별 합계까지 나옴
SELECT DEPT_COD, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;


-- 집합연산자
-- A = {1, 2, 4} B = {2, 5, 7}
-- A∩B = {2} 교집합
-- A∪B = {1, 2, 4, 5, 7} 합집합
-- A－B = {1, 4} 차집합
-- A－A∩B = {1, 4}

-- 교집합 → INTERSECT
-- 합집합 → UNION(중복제거), UNION ALL
-- 교집합 → MINUS
-- ResultSet이란?

-- 교집합 연산
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
INTERSECT
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- 합집합1 (중복 허용)
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
UNION ALL
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- 합집합1 (중복 제거)
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
UNION
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- 차집합 연산
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
MINUS
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;

-- **UNION의 조건**
--1. SELECT문의 컬럼 갯수가 반드시 같아야 함
-- ORA-01789: query block has incorrect number of result colums
--2. 컬럼의 데이터 타입이 반드시 같거나 변환가능해야함 ex. CHAR - VARCHAR2
-- ORA-01790: expression must have same datatype as corresponding expression
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
MINUS
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;


-- #조인문 (JOIN)
-- 여러 테이블의 레코르를 조합하여 하나의 열로 표현한 것
-- 두 개 이상의 테이블에서 연관성을 가지고 있는 데이터들을 컬럼 기중으로 분류하여
-- 새로운 가상의 테이블을 이용하여 출력함
-- 다시말해, 서로 다른 테이블에서 각각의 공통값을 이용함으로서 필드를 조합함.

--11. 사원명과 부서명을 출력하세요.
--   부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.
SELECT EMP_NAME, DECODE(DEPT_CODE, 'D9', '총무부', 'D5', '해외영업1부', 'D6', '해외영업2부')
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9');
SELECT * FROM DEPARTMENT;

SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE;
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

-- #조인문
-- SELECT 컬럼명 FROM 테이블 JOIN 테이블 ON 컬럼명1 = 컬럼명2
-- ANSI 표준구문
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID;

-- JOIN의 종류
-- 1. Equi-JOIN : 일반적으로 사용, =에 의한 조건
-- 2. NON-Equi-JOIN : 동등조건이 아닌 BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN 등으로 사용

-- @실습문제
--1. 부서명과 지역명을 출력하세요. DEPARTMENT, LOCATION 테이블 이용.
SELECT DEPT_TITLE, LOCAL_NAME FROM DEPARTMENT 
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

--2. 사원명과 직급명을 출력하세요. EMPLOYEE, JOB 테이블 이용
-- ORA-00918: column ambiguously defined
-- 모호한 것을 해결하는 방법1
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE 
JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
-- 모호한 것을 해결하는 방법2
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE EMP 
JOIN JOB JB ON EMP.JOB_CODE = JB.JOB_CODE;
-- 모호한 것을 해결하는 방법3
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE);

-- 3. 지역명과 국가명을 출력하세요. LOCATION, NATION 테이블 이용
SELECT LOCAL_NAME, NATIONAL_NAME FROM LOCATION
JOIN NATIONAL USING(NATIONAL_CODE);
--JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

SELECT LOCAL_NAME, NATIONAL_NAME FROM NATIONAL
JOIN LOCATION USING(NATIONAL_CODE);

-- ORA-00918: column ambiguously defined
SELECT * FROM NATIONAL;


-- ## INNER JOIN
-- ## INNRT EQUI JOIN

-- ## JOIN의 종류2
-- INNER JOIN(내부조인) : 일반적으로 사용하는 조인(교집합)
-- OUTER JOIN(외부조인) : 합집합, 모두 출력
-- → 1. LEFT (OUTER) JOIN
-- → 2. RIGHT (OUTER) JOIN
-- → 3. FULL (OUTER) JOIN

-- 그냥 JOIN은 사실 INNER가 생략된것
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
INNER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- LEFT JOIN
-- ANSI 표준구문
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID(+);

-- RIGHT JOIN
-- ANSI 표준구문
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;

-- FULL JOIN
-- ANSI 표준구문만 존재
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- ex) OUTER JOIN(외부조인) 살펴보기
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT EMP_NAME, DEPT_TITLE FROM DEPARTMENT 
RIGHT JOIN EMPLOYEE ON DEPT_ID = DEPT_CODE;


-- ##JOIN의 종류3
-- 1. 상호조인 (CROSS JOIN)
-- 2. 셀프조인 (SELF JOIN)

-- 3. 다중조인 → 여러개의 조인문을 한번에 사용 할 수 있음
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
-- ORA-00904: "LOCATION_ID":invalid identifier
-- **순서가 중요하다**


--@실습문제
-- 1. 직급이 대리이면서, ASIA 지역에 근무하는 직원 조회
-- 사번, 이름 ,직급명, 부서명, 근무지역명, 급여를 조회하시오
SELECT EMP_ID AS 사번, EMP_NAME AS 이름
, JOB_NAME AS 직급명, DEPT_TITLE AS 부서명
, LOCAL_NAME AS 근무지역명, SALARY AS 급여 
FROM EMPLOYEE
-- EMP-JOB → EMP-DEPT → DEPT-LOCA순서로 조인
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
-- WHERE JOB_NAME = '대리' AND LOCAL_NAME IN ('ASIA1', 'ASIA2', 'ASIA3');
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';


--@조인실습문제
--1. 2022년 12월 25일이 무슨 요일인지 조회하시오.


--2. 주민번호가 1970년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '전%' AND (SUBSTR(EMP_NO,1,2) BETWEEN 70 AND 79);

--3. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
SELECT EMP_ID, EMP_NAME, DEPT_TITLE FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '%형%';

--5. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.


--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.


--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.


--8. 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
-- (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것)


--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.


--10. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오. 단, join과 IN 사용할 것


--11. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.

