--@DQL���սǽ�����
--����1
--��������ο� ���� ������� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�.
SELECT EMP_NAME AS �̸�, DEPT_CODE AS �μ��ڵ�, SALARY AS �޿�
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '���������';

--����2
--��������ο� ���� ����� �� ���� ������ ���� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�
SELECT EMP_NAME AS �̸�, DEPT_CODE AS �μ��ڵ�, SALARY AS �޿�
FROM EMPLOYEE E
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '���������' 
AND SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE DEPT_TITLE = '���������');

--����3
--�Ŵ����� �ִ� ����߿� ������ ��ü��� ����� �Ѱ� 
--���,�̸�,�Ŵ��� �̸�, ������ ���Ͻÿ�.
SELECT EMP_ID AS ���, EMP_NAME AS �̸�
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS "�Ŵ��� �̸�", SALARY AS ����
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);



-- ##�������
-- ### 1. TOP-N�м�
-- ### 2. WITH
-- ### 3. ������ ����(Hierarchical Query)
-- ### 4. ������ �Լ�
-- #### 4.1 ���� �Լ�




-- ## JOIN�� ����3
-- 1. ��ȣ����(CROSS JOIN)
-- ī���̼� �� (Cartensial Product)��� ��
-- ���εǴ� ���̺��� �� ����� ��� ���ε� ���� ���
-- �ٽø���, ���� ���̺��� ��� ��� �ٸ��� ���̺��� ��� ���� ���� ��Ŵ
-- ������� ���� ���ϹǷ� ����� �� ���̺��� �÷����� ���� ������ ����
-- 4 * 3 = ?
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE CROSS JOIN DEPARTMENT;
--@�ǽ�����
--�Ʒ�ó�� �������� �ϼ���.
----------------------------------------------------------------
-- �����ȣ    �����     ����    ��տ���    ����-��տ���
----------------------------------------------------------------
SELECT EMP_ID AS �����ȣ, EMP_NAME AS �����, SALARY AS ����
, AVG_SAL AS ��տ���
, (CASE WHEN SALARY-AVG_SAL > 0 THEN '+' END )||(SALARY-AVG_SAL) AS "����-��տ���"
FROM EMPLOYEE
CROSS JOIN (SELECT ROUND (AVG(SALARY)) "AVG_SAL" FROM EMPLOYEE);


-- 2. ��������(SELF JOIN)
-- �Ŵ����� �ִ� ����߿� ������ ��ü��� ����� �Ѵ� ���� ���,�̸�,�Ŵ��� �̸�, ������ ���Ͻÿ�.
SELECT EMP_ID AS ���, EMP_NAME AS �̸�
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS "�Ŵ��� �̸�", SALARY AS ����
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);
-- ��������� �̿��� �Ŵ��� �̸� ���ϱ� ��� ���� ���� ���� ������ �̿��ؼ� ���� �� ����
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_NAME, E.SALARY
FROM EMPLOYEE E
JOIN EMPLOYEE M
ON M.EMP_ID = E.MANAGER_ID;

SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE;



-- # ��������
-- ## 1. CHECK

-- 1. ���̺� USER_CHECK, CHAR(1) �Ǽ�
-- 2. CHAR(1) -> CHAR(3)
-- 3. INSERT INTO, 4���� ����
-- 4. CHECK ����, �̹� ������� ���̺��̶� ALTER TABLE
-- 5. BUT M,F�� �� �־ DELETE FROM, 4���� ����
-- 6. ALTER TABLE ADD�� �������� �߰�
-- 7. INSERT INTO �ؼ� M, F�� ������ �� Ȯ��('��','��'�� ��)

CREATE TABLE USER_CHECK (
    USER_NO NUMBER PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_GENDER CHAR(1)
--  USER_GENDER CHAR(1) CONSTRAINT GENDER_VAR CHECK(USER_GENDER IN('��', '��'));
);
-- �̹� ���̺��� ����� ���� ���¿��� �������� ����
ALTER TABLE USER_CHECK
MODIFY USER_GENDER CHAR(3);
-- 4�� �� ��(��) �����Ǿ����ϴ�.
DELETE FROM USER_CHECK;
-- �̹� ���̺��� ����� ���� ���¿��� �������� �߰�
ALTER TABLE USER_CHECK
ADD CONSTRAINT GENDER_VAR CHECK(USER_GENDER IN('��', '��'));

INSERT INTO USER_CHECK VALUES('1', '�Ͽ���', '��');
INSERT INTO USER_CHECK VALUES('2', '�̿���', '��');
-- ORA-02290: check constraint (KH.GENDER_VAR) violated
INSERT INTO USER_CHECK VALUES('3', '�����', 'M');
INSERT INTO USER_CHECK VALUES('4', '�����', 'F');


-- ## 2. DEFAULT
-- DDL, DML, DCL, TCL
CREATE TABLE USER_DEFAULT(
    USER_NO NUMBER CONSTRAINT USERNO_PK PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_DATE DATE DEFAULT SYSDATE,
    USER_YN CHAR(1) DEFAULT 'Y'
);
-- ���Գ�¥, ȸ�� ���� �� �÷��� �⺻���� ������ �� ����
DROP TABLE USER_DEFAULT;
-- Table USER_DEFAULT��(��) �����Ǿ����ϴ�.
-- DROP�� �δ�Ǹ� ALTER TABLE ���
INSERT INTO USER_DEFAULT VALUES('1', '�Ͽ���', '2022/12/23', 'Y');
INSERT INTO USER_DEFAULT VALUES('2', '�Ͽ���', SYSDATE, 'N');


-- TCL
-- Ʈ������̶�?
-- �Ѳ����� ����Ǿ�� �� �ּ��� �۾� ������ ����, 
-- �ϳ��� Ʈ��������� �̷���� �۾����� �ݵ�� �Ѳ����� �Ϸᰡ �Ǿ�� �ϸ�,
-- �׷��� ���� ��쿡�� �Ѳ����� ��� �Ǿ�� ��
-- TCL�� ����
-- 1. COMMIT : Ʈ����� �۾��� ���� �Ϸ� �Ǹ� ���� ������ ������ ���� (��� savepoint ����)
-- 2. ROLLBACK : Ʈ����� �۾��� ��� ����ϰ� ���� �ֱ� commit �������� �̵�
-- 3. SAVEPOINT : ���� Ʈ����� �۾� ������ �̸��� ������, �ϳ��� Ʈ����� �ȿ��� ������ ������ ����
-- 4. ROLLBACK TO ���̺�����Ʈ�� : Ʈ����� �۾��� ����ϰ� savepoint �������� �̵�

INSERT INTO USER_DEFAULT VALUES('1', '�Ͽ���', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES('2', '�̿���', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES('3', '�����', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES('4', '�����', DEFAULT, DEFAULT); -- ����Ŀ��, Ʈ����� ����
INSERT INTO USER_DEFAULT VALUES('5', '������', DEFAULT, DEFAULT); -- �ӽ����� SAVEPOINT
SAVEPOINT temp1;
INSERT INTO USER_DEFAULT VALUES('6', '������', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES('7', 'ĥ����', DEFAULT, DEFAULT);
ROLLBACK;
ROLLBACK TO temp1;
COMMIT;
SELECT * FROM USER_DEFAULT;


-- DCL(Data Control Language)
-- ������ ����� �� System�������� �ؾ߸� ��!
-- DB�� ���� ����, ���Ἲ, ���� �� DBMS�� �����ϱ� ���� ���
-- ���Ἲ�̶�? ��Ȯ��, �ϰ����� �����ϴ� ��
-- ������� �����̳� ������ �������� ó��
-- DCL�� ����
-- 1. GRANT : ���� �ο�
-- 2. REVOKE : ���� ȸ��
-- GRANT CONNECT, RESOURCE TO STUDENT; �� System�������� �����ؼ� �ϱ�!
-- CONNECT, RESOURCE = ��(ROLL) ���� ���� �������� ���ִ�.
-- ���� �ʿ��� ������ ��� ������ ��, �ο� �� ȸ���� �� ���ϴ�.
-- ROLE
-- CONNECT�� : CREATE SESSION
-- RESOURCE�� : CREATE CLUSTER, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE
--             CREATE TRIGGER, CREATE TYPE, CREATE INDEXTYPE, CREATE OPERATOR;


--## Oracle Object (����Ŭ ��ü)
-- DB�� ȿ�������� ���� �Ǵ� �����ϰ� �ϴ� ���
--## Oracle Object�� ����
-- ���̺�(TABLE), ��(VIEW), ������(SEQUENCE), �ε���(INDEX), ��Ű��(PACKAGE), 
-- ���ν���(PROCEDUAL), �Լ�(FUNCTION), Ʈ����(TRIGGER), ���Ǿ�(SYNONYM), �����(USER)
SELECT DISTINCT OBJECT_TYPE FROM ALL_OBJECTS;
--### 1. VIEW
-- �ϳ� �̻��� ���̺��� ���ϴ� �����͸� �����Ͽ� ������ ���̺��� ����� �ִ°�
-- �ٸ����̺� �ִ� �����͸� ������ ���̸�, ������ ��ü�� �����ϰ� �ִ� ���� �ƴ�
-- ��, ������ġ ���� ���������� �������� �ʰ� �������̺�� �������
-- �������� ���� ���̺���� ��ũ ����
-- �並 ����ϸ� Ư�� ����ڰ� ���� ���̺� �����Ͽ� ��� �����͸� ���� �ϴ°��� ������ �� ����.
-- �ٽø���, ���� ���̺��� �ƴ� �並 ���� Ư�� �����͸� �������� ����
-- �並 ����� ���ؼ��� ������ �ʿ���. RESUOURCE�ѿ��� ���� �Ǿ����� ���� �����ǡ�

-- GRANT CREATE VIEW TO KH; (�ý��۰������� ����)
-- Grant��(��) �����߽��ϴ�.

-- View�����ϱ�
CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;
SELECT * FROM (SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE);

SELECT * FROM V_EMPLOYEE
WHERE EMP_ID = 200;

-- View�����ϱ�
UPDATE V_EMPLOYEE
SET DEPT_CODE = 'D8'
WHERE EMP_ID = 200;
-- 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.
-- �������̺� Ȯ���غ��� �����Ǿ�����!
SELECT * FROM EMPLOYEE WHERE EMP_ID = 200;
-- View�� ������ �����ϴ�
-- View�����ϱ�2 (View�� ���� �÷� ����)
UPDATE V_EMPLOYEE
SET SALARY = 600000
WHERE EMP_ID = 200;
-- ORA-00904: "SALARY": invalid identifier �Ұ�����

-- View�����ϱ�
DROP VIEW V_EMPLOYEE;

CREATE VIEW V_EMP_READ
AS SELECT EMP_ID, DEPT_TITLE FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT * FROM V_EMP_READ;


--### 1. SEQUENCE(������)
-- ���������� �������� �ڵ����� �����ϴ� ��ü�� �ڵ���ȣ�߻���(ä����)�� ������ ��
-- CREATE SEQUENCE ��������
-- ���������� �ɼ��� 6�� ���� - START WITH, INCREMENT BY, MAXVALUE, CYCLE, CACHE
SELECT * FROM USER_DEFAULT;
COMMIT;
-- Ŀ�� �Ϸ�.
DELETE FROM USER_DEFAULT;
-- 4�� �� ��(��) �����Ǿ����ϴ�.
INSERT INTO USER_DEFAULT VALUES (1, 'khuser01', DEFAULT, DEFAULT);
-- ORA-00001: unique constraint (KH.USERNO_PK) violated
-- ������(�ڵ���ȣ�߻���) ����
CREATE SEQUENCE SEQ_USERNO;
-- ������ ����
DROP SEQUENCE SEQ_USERNO;
-- Sequence SEQ_USERNO��(��) �����Ǿ����ϴ�.
-- ������� ������ Ȯ��
SELECT * FROM USER_SEQUENCES;
-- ��� ��� ����?
INSERT INTO USER_DEFAULT VALUES (SEQ_USERNO.NEXTVAL, '������', DEFAULT, DEFAULT);
SELECT SEQ_USERNO.CURRVAL FROM DUAL;
-- �������� INSERT�� �� ������ �߻��ص� ������ ���� ������

-- ������ �ߴµ� SEQ_USERNO.NEXTVAL�� 1���� ���ٵ� �̹� 1���� ������ �켱 ����
DELETE FROM USER_DEFAULT;
SELECT * FROM USER_DEFAULT ORDER BY 1;
-- ������ ���� ����Ϸ��� KH001, K-01-1���� ���·� ����� ���°��� ����.

-- NAXTVAL, CURRVAL ����� �� �ִ� ���
-- 1. ���������� �ƴ� SELECT��
-- 2. INSERT���� SELECT��
-- 3. INSERT���� VALUES��
-- 4. UPDATE���� SET��

-- CURRVAL�� ����� �� ������ ��
-- NAXTVAL�� ������ 1�� ������ �Ŀ� CURRVAL�� �� �� ����

-- ������ ����
-- START WITH���� ������ �Ұ����ϱ� ������ �����Ϸ��� ���� �� �ٽ� �����ؾ���.
CREATE SEQUENCE SEQ_SAMPLE1;
-- Sequence SEQ_SAMPLE1��(��) �����Ǿ����ϴ�.
SELECT * FROM USER_SEQUENCES;
ALTER SEQUENCE SEQ_SAMPLE1
INCREMENT BY 10;
-- Sequence SEQ_SAMPLE1��(��) ����Ǿ����ϴ�.


-- DAY07�� �ִ� ����(��)
-- ������ J1, J2, J3�� �ƴ� ����߿��� �ڽ��� �μ��� ��ձ޿����� ���� �޿��� �޴� ������.
-- �μ��ڵ�, �����, �޿�, �μ��� �޿����
SELECT
    E.DEPT_CODE AS �μ��ڵ�
    , E.EMP_NAME AS �����
    , E.SALARY AS �޿�
    , AVG_SAL AS "�μ��� �޿����"
FROM EMPLOYEE E
JOIN (SELECT DEPT_CODE, CEIL(AVG(SALARY)) "AVG_SAL"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE) A ON E.DEPT_CODE = A.DEPT_CODE
WHERE JOB_CODE NOT IN('J1', 'J2', 'J3') AND E.SALARY > AVG_SAL;


