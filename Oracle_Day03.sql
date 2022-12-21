-- 부모테이블
CREATE TABLE USER_GRADE (
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
DESC USER_GRADE;
SELECT * FROM USER_GRADE;

INSERT INTO USER_GRADE VALUES (10, '일반회원');
INSERT INTO USER_GRADE VALUES (20, '우수회원');
INSERT INTO USER_GRADE VALUES (30, '특별회원');

-- 자식테이블
CREATE TABLE USER_FOREIGNKEY (
    USER_NO NUMBER CONSTRAINT USER_NO_PK PRIMARY KEY,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(30) NOT NULL,
    USER_NAME VARCHAR2(30),
    GENDER VARCHAR2(10),
    EMAIL VARCHAR2(50),
    GRADE_CODE CONSTRAINT GRADE_CODE_FK REFERENCES USER_GRADE(GRADE_CODE)
);

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'USER_FOREIGNKEY';
DESC USER_CONSRAINTS;

INSERT INTO USER_FOREIGNKEY
VALUES(1, 'user01', 'pass01', '일용자', '남', 'user01@iei.com', 10);
INSERT INTO USER_FOREIGNKEY
VALUES(2, 'user02', 'pass02', '이용자', '남', 'user02@iei.com', 20);
INSERT INTO USER_FOREIGNKEY
VALUES(3, 'user03', 'pass03', '삼용자', '남', 'user03@iei.com', 30);
INSERT INTO USER_FOREIGNKEY
VALUES(4, 'user04', 'pass04', '사용자', '남', 'user04@iei.com', 40);
-- ORA-02291: integrity constraint (KH.GRADE_CODE_FK) violated - parent key not found



-- 제약조건 걸려있는 부모테이블 레코드 지우기
SELECT GRADE_CODE, GRADE_NAME FROM USER_GRADE;
DELETE FROM USER_GRADE
WHERE GRADE_CODE = 10;
SELECT * FROM USER_FOREIGNKEY;
-- ORA-02292: integrity constraint (KH.GRADE_CODE_FK) violated - child record found
-- 외래키(자식테이블)가 참조하는 부모테이블 컬럼데이터는 기본적으로 지워지지 않는다. 
-- 삭제 옵션 2가지를 이용해 지우는 방법이 있다.
-- 1. ON DELETE SET NULL; → 부모테이블 데이터 지우고 자식테이블 데이터는 NULL로 바꿔줌
-- 2. ON DELETE CASCADE; → 부모테이블 데이터 지우고 자식테이블 데이터도 지워줌
ALTER TABLE USER_FOREIGNKEY
DROP CONSTRAINT GRADE_CODE_FK;
-- Table USER_FOREIGNKEY이(가) 변경되었습니다.
COMMIT;
-- 커밋 완료.
ROLLBACK;
-- 롤백 완료.
ALTER TABLE USER_FOREIGNKEY
ADD CONSTRAINT GRADE_CODE_FK FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE(GRADE_CODE)
ON DELETE SET NULL;

ALTER TABLE USER_FOREIGNKEY
ADD CONSTRAINT GRADE_CODE_FK FOREIGN KEY(GRADE_CODE) REFERENCES USER_GRADE(GRADE_CODE)
ON DELETE CASCADE;

-- Table USER_FOREIGNKEY이(가) 변경되었습니다.
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='USER_FOREIGNKEY';



-- 별칭 표시 "" AS를 쓰지 않아도 됨
SELECT EMP_NAME, SALARY, SALARY*12 "연봉(보너스 미포함)"
    , BONUS, (SALARY*BONUS + SALARY*12) AS "연봉(보너스 포함)"
FROM EMPLOYEE
-- 논리연산자 AND OR
WHERE SALARY > 3000000 OR EMP_NAME = '선동일'
ORDER BY BONUS ASC;
-- FROM → WHERE → SELECT → ORDER BY는 맨마지막에 실행 됨
-- ASC 오름차순 / DESC 내림차순
-- NULL을 포함하는 컬럼정렬 : ASC일때 NULL맨 위에, DESC일때 맨 앞에


SELECT EMP_NAME, SALARY
FROM EMPLOYEE
-- WHERE SALARY > 2000000 AND SALARY < 6000000;
WHERE SALARY BETWEEN 2000000 AND 6000000;


SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE DEPT_CODE = 'D6' OR DEPT_CODE ='D8';
WHERE DEPT_CODE IN('D6', 'D8');


-- IS NULL / IS NOT NULL 연산자
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
-- WHERE BONUS IS NOT NULL;
WHERE BONUS IS NULL;


-- LIKE 연산자
-- 전씨 성을 가진 직원의 이름과 급여를 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';


-- 와일드카드
-- 1. % : 0개 이상의 모든 문자를 매칭
-- 2. _(언더바) : 하나의 자리에 해당하는 모든 문자를 매칭


-- 실습문제
--1. EMPLOYEE 테이블에서 이름 끝이 연으로 끝나는 사원의 이름을 출력하시오
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '__연';

--2. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를
--출력하시오
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

--3. EMPLOYEE 테이블에서 메일주소의 's'가 들어가면서, DEPT_CODE가 D9 또는 D6이고
--고용일이 90/01/01 ~ 01/12/01이면서, 월급이 270만원이상인 사원의 전체 정보를 출력하시오
SELECT * FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/12/01'
AND EMAIL LIKE '%s%'
AND SALARY >= 2700000
-- AND (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6');
AND DEPT_CODE IN ('D9', 'D6');

--4. EMPLOYEE 테이블에서 EMAIL ID 중 @ 앞자리가 5자리인 직원을 조회한다면?
SELECT EMP_NAME, EMAIL FROM EMPLOYEE
WHERE  EMAIL LIKE '_____@%';

--5. EMPLOYEE 테이블에서 EMAIL ID 중 '_' 앞자리가 3자리인 직원을 조회한다면?
SELECT * FROM EMPLOYEE
WHERE EMAIL  LIKE '___#_%' ESCAPE '#';

--6. 관리자(MANAGER_ID)도 없고 부서 배치(DEPT_CODE)도 받지 않은  직원의 이름 조회
SELECT EMAIL FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPR_COD IS NULL;

--7. 부서배치를 받지 않았지만 보너스를 지급하는 직원 전체 정보 조회
SELECT * FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

--8. EMPLOYEE 테이블에서 이름, 연봉, 총수령액(보너스포함),
-- 실수령액(총 수령액 - (월급*세금 3%*12))가 출력되도록 하시오
SELECT EMP_NAME AS "이름", SALARY*12 "연봉", SALARY*12 + BONUS "총수령액(보너스포함)",
(SALARY*12 + BONUS)-(SALARY*0.03*12) "실수령액"
FROM EMPLOYEE;

--9. EMPLOYEE 테이블에서 이름, 근무일수를 출력해보시오
--(SYSDATE를 사용하면 현재시간 출력)
SELECT EMP_NAME "이름", HIRE_DATE, SYSDATE - HIRE_DATE "근무일수" FROM EMPLOYEE;

--10. EMPLOYEE 테이블에서 20년 이상 근속자의 이름, 월급, 보너스율을 출력하시오.
SELECT EMP_NAME "이름", SLSRY "월급", BONUS "보너스율" FROM EMPLOYEE
WHERE (SYSDATE - HIRE_DATE)/365 >= 20;


DESC EMPLOYEE;