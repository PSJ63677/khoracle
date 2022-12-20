-- Oracle day05
-- 그룹함수
-- 여러개의 값이 들어가서 하 행의 결과만 나오는 함수
-- SUM, AVG, COUNT, MAX, MIN

--@실습예제
--1. [EMPLOYEE] 테이블에서 남자 사원의 급여 총 합을 계산
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999,999') "급여 총 합"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

--2. [EMPLOYEE]테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉을 계산
SELECT TO_CHAR(SUM(SALARY*12+SALARY*NVL(BONUS,0)), 'L999,999,999,999') "연봉"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--3. [EMPLOYEE] 테이블에서 전 사원의 보너스 평균을 소수 둘째짜리에서 반올림하여 구하여라
SELECT ROUND(AVG(NVL(BONUS,0)),2)
FROM EMPLOYEE;

--4. [EMPLOYEE] 테이블에서 D5 부서에 속해 있는 사원의 수를 조회
SELECT COUNT(EMP_NAME) "사원의 수",  COUNT(*) "빠름"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
-- ex) EMPLOYEE테이블에 저장된 데이터의 수를 구하시오
SELECT COUNT(*)
FROM EMPLOYEE;

--5. [EMPLOYEE] 테이블에서 사원들이 속해있는 부서의 수를 조회 (NULL은 제외됨)
SELECT COUNT(DISTINCT DEPT_CODE) "부서의 수"
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

--6. [EMPLOYEE] 테이블에서 사원 중 가장 높은 급여와 가장 낮은 급여를 조회
SELECT MAX(SALARY), MIN(SALARY) FROM EMPLOYEE;

--7. [EMPLOYEE] 테이블에서 가장 오래된 입사일과 가장 최근 입사일을 조회하시오
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE) FROM EMPLOYEE;


-- # GROUP BY절
-- 별도의 그룹 지정없이 사용한 그룹함수는 단한개의 결과값만 산출하기 때문에
-- 그룹함수를 이용하여 여러개의 결과값을 산출하기 위해서는
-- 그룹함수가 적용될 그룹의 기준을 GROUP BY절에 기술하여 사용해야 함.
-- ex)
-- not a GROUP BY expression
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;
--GROUP BY DEPT_CODE;
-- ORA-00937: not a single-group group function

-- 직급별 급여합계를 구해보시오
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

--[EMPLOYEE] 테이블에서 부서코드 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리),
-- 인원수를 조회하고, 부서코드 순으로 정렬
SELECT DEPT_CODE, SUM(SALARY), FLOOR(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE;

--[EMPLOYEE] 테이블에서 부서코드 그룹별, 보너스를 지급받는 사원 수를 조회하고 부서코드 순으로 정렬
-- BONUS컬럼의 값이 존재한다면, 그 행을 1로 카운팅.
-- 보너스를 지급받는 사원이 없는 부서도 있음.
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
--WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY 1;
-- FROM → WHERE → GROUP BY → SELECT → ORDER BY


--@실습문제
--1. EMPLOYEE 테이블에서 직급이 J1을 제외하고, 직급별 사원수 및 평균급여를 출력하세요.


--2. EMPLOYEE테이블에서 직급이 J1을 제외하고,  입사년도별 인원수를 조회해서, 입사년 기준으로 오름차순 정렬하세요.

--3. [EMPLOYEE] 테이블에서 EMP_NO의 8번째 자리가 1, 3 이면 '남', 2, 4 이면 '여'로 결과를 조회하고,
-- 성별별 급여의 평균(정수처리), 급여의 합계, 인원수를 조회한 뒤 인원수로 내림차순을 정렬 하시오

--4. 부서내 성별 인원수를 구하세요.

--5. 부서별 급여 평균이 3,000,000원(버림적용) 이상인  부서들에 대해서 부서명, 급여평균을 출력하세요.
