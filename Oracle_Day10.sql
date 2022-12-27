-- PL/SQL
-- 익명블록
SET SERVEROUTPUT ON;
DECLARE
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_NAME, SALARY
    INTO VENAME, VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&사원번호';
    IF(VSALARY >= 1000000)
    THEN DBMS_OUTPUT.PUT_LINE('이름 : '||VENAME);
    ELSIF(VSALARY < 2000000)
    THEN DBMS_OUTPUT.PUT_LINE('사이값입니다.');
    ELSE DBMS_OUTPUT.PUT_LINE('적당히 받습니다.');
    END IF;
--EXCEPTION
END;
/

DECLARE
    VSAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT SALARY
    INTO VSAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMPID';
    VSAL := VSAL / 1000000;
    CASE FLOOR(VSAL)
        WHEN 0 THEN DBMS_OUTPUT.PUT_LINE('F등급입니다.');
        WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('E등급입니다.');
        WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('D등급입니다.');
        WHEN 3 THEN DBMS_OUTPUT.PUT_LINE('C등급입니다.');
        WHEN 4 THEN DBMS_OUTPUT.PUT_LINE('B등급입니다.');
        ELSE DBMS_OUTPUT.PUT_LINE('A등급입니다.');
    END CASE;
END;
/

-- 1. 변수선언, SELECT결과 변수에 담고
-- 2. IF THEN END IF; 써보기
-- 3. CASE END CASE; 써보기
----------------------------------------
-- # PL/SQL 반복문
-- 1. LOOP END LOOP;
-- 2. FOR END LOOP;
-- 3. WHILE LOOP;

-- 기본 LOOP문
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
        IF N > 5 THEN EXIT;
        END IF;
    END LOOP;
END;
/

-- ## FOR LOOP
-- 카운트용 변수가 자동으로 선언됨 (DECLARE 필요없음)
-- 따로 변수를 선언할 필요없음
-- 카운트 값은 자동으로 1씩 증가함. REVERSE를 사용하면 1씩 감소함.
BEGIN
    FOR N IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/
-- ## REVERSE
BEGIN
    FOR N IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/
-- EMPLOYEE 테이블에서 사원번호가 201, 202, 203, 204인 직원의 이름과 급여를 출력하시오
DECLARE
    VNAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    FOR N IN 1..4 LOOP
        SELECT EMP_NAME, SALARY
        INTO VNAME, SALARY
        FROM EMPLOYEE
        WHERE EMP_ID = 200 + N;
        DBMS_OUTPUT.PUT_LINE('이름 : '||VNAME);
        DBMS_OUTPUT.PUT_LINE('급여 : '||SALARY);
    END LOOP;
END;
/

-- 실습문제
-- 사용자로부터 2~9사이의 수를 입력받아 구구단 출력하시오
-- 기본 LOOP문
DECLARE
    DAN NUMBER;
    N NUMBER := 1;
BEGIN
    DAN := '&단';
    LOOP
        DBMS_OUTPUT.PUT_LINE(DAN||' * '|| N || ' = ' || DAN*N);
        N := N+1;
        IF(N > 9) THEN EXIT;
        END IF;
    END LOOP;
END;
/
-- FOR LOOP문 : 변수선언 할 필요 없다!
DECLARE
    DAN NUMBER;
BEGIN
    DAN := '&단';
    FOR N IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE(DAN||' * '|| N || ' = ' || DAN*N);
    END LOOP;
END;
/
-- WHILE LOOP문
DECLARE
    DAN NUMBER;
    N NUMBER := 1;
BEGIN
    DAN := '&단';
    WHILE N <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE(DAN||' * '|| N || ' = ' || DAN*N);
        N := N+1;
    END LOOP;
END;
/

-- # 예외처리
--DECLARE
--BEGIN
--EXCEPTION
--END;
--/
-- # Exception의 종류
/*
    1. ACCESS_INTO_NULL
    2. CASE_NOT_FOUND
    3. COLLECTION_IS_NULL
    4. CURSOR_ALREADY_OPEN
    ...
    5. LOGIN_DENIED
    6. NO_DATA_FOUND
*/
/*
    EXCEPTION
        WHEN 예외이름1 THEN 처리문장1
        WHEN 예외이름2 THEN 처리문장2
    END;
    /
*/
-- PL/SQL과 관련된 오라클 객체
-- Function, Procedure, Cursor, Package, Trigger, Job, ..