-- 사용자 계정 생성, 권한 부여 및 해제
CREATE USER STUDENT IDENTIFIED BY STUDENT;
-- 사용자 계정 생성   비밀번호는 대소문자 구분한다

-- 명령어 실행 상단 재생버튼▷ / Ctrl+Enter

GRANT CONNECT TO STUDENT;

GRANT RESOURCE TO STUDENT;


CREATE USER KH IDENTIFIED BY KH;

GRANT CONNECT, RESOURCE TO KH;