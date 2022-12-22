--# ROLLUP�� CUBE
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- �μ��� ���޺� �޿� �հ�
SELECT DEPT_COD, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;
-- CUBE: �μ����հ� + ���޺� �հ���� ����
SELECT DEPT_COD, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;


-- ���տ�����
-- A = {1, 2, 4} B = {2, 5, 7}
-- A��B = {2} ������
-- A��B = {1, 2, 4, 5, 7} ������
-- A��B = {1, 4} ������
-- A��A��B = {1, 4}

-- ������ �� INTERSECT
-- ������ �� UNION(�ߺ�����), UNION ALL
-- ������ �� MINUS
-- ResultSet�̶�?

-- ������ ����
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
INTERSECT
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- ������1 (�ߺ� ���)
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
UNION ALL
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- ������1 (�ߺ� ����)
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
UNION
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- ������ ����
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
MINUS
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;

-- **UNION�� ����**
--1. SELECT���� �÷� ������ �ݵ�� ���ƾ� ��
-- ORA-01789: query block has incorrect number of result colums
--2. �÷��� ������ Ÿ���� �ݵ�� ���ų� ��ȯ�����ؾ��� ex. CHAR - VARCHAR2
-- ORA-01790: expression must have same datatype as corresponding expression
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE='D5'
MINUS
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;


-- #���ι� (JOIN)
-- ���� ���̺��� ���ڸ��� �����Ͽ� �ϳ��� ���� ǥ���� ��
-- �� �� �̻��� ���̺��� �������� ������ �ִ� �����͵��� �÷� �������� �з��Ͽ�
-- ���ο� ������ ���̺��� �̿��Ͽ� �����
-- �ٽø���, ���� �ٸ� ���̺��� ������ ���밪�� �̿������μ� �ʵ带 ������.

--11. ������ �μ����� ����ϼ���.
--   �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.(case ���)
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ�ϰ�, �μ��ڵ� �������� �������� ������.
SELECT EMP_NAME, DECODE(DEPT_CODE, 'D9', '�ѹ���', 'D5', '�ؿܿ���1��', 'D6', '�ؿܿ���2��')
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9');
SELECT * FROM DEPARTMENT;

SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE;
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

-- #���ι�
-- SELECT �÷��� FROM ���̺� JOIN ���̺� ON �÷���1 = �÷���2
-- ANSI ǥ�ر���
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- ����Ŭ ���� ����
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID;

-- JOIN�� ����
-- 1. Equi-JOIN : �Ϲ������� ���, =�� ���� ����
-- 2. NON-Equi-JOIN : ���������� �ƴ� BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN ������ ���

-- @�ǽ�����
--1. �μ���� �������� ����ϼ���. DEPARTMENT, LOCATION ���̺� �̿�.
SELECT DEPT_TITLE, LOCAL_NAME FROM DEPARTMENT 
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

--2. ������ ���޸��� ����ϼ���. EMPLOYEE, JOB ���̺� �̿�
-- ORA-00918: column ambiguously defined
-- ��ȣ�� ���� �ذ��ϴ� ���1
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE 
JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
-- ��ȣ�� ���� �ذ��ϴ� ���2
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE EMP 
JOIN JOB JB ON EMP.JOB_CODE = JB.JOB_CODE;
-- ��ȣ�� ���� �ذ��ϴ� ���3
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE);

-- 3. ������� �������� ����ϼ���. LOCATION, NATION ���̺� �̿�
SELECT LOCAL_NAME, NATIONAL_NAME FROM LOCATION
JOIN NATIONAL USING(NATIONAL_CODE);
--JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

SELECT LOCAL_NAME, NATIONAL_NAME FROM NATIONAL
JOIN LOCATION USING(NATIONAL_CODE);

-- ORA-00918: column ambiguously defined
SELECT * FROM NATIONAL;


-- ## INNER JOIN
-- ## INNRT EQUI JOIN

-- ## JOIN�� ����2
-- INNER JOIN(��������) : �Ϲ������� ����ϴ� ����(������)
-- OUTER JOIN(�ܺ�����) : ������, ��� ���
-- �� 1. LEFT (OUTER) JOIN
-- �� 2. RIGHT (OUTER) JOIN
-- �� 3. FULL (OUTER) JOIN

-- �׳� JOIN�� ��� INNER�� �����Ȱ�
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
INNER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- LEFT JOIN
-- ANSI ǥ�ر���
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- ����Ŭ ���� ����
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE = DEPT_ID(+);

-- RIGHT JOIN
-- ANSI ǥ�ر���
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- ����Ŭ ���� ����
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;

-- FULL JOIN
-- ANSI ǥ�ر����� ����
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- ex) OUTER JOIN(�ܺ�����) ���캸��
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT EMP_NAME, DEPT_TITLE FROM DEPARTMENT 
RIGHT JOIN EMPLOYEE ON DEPT_ID = DEPT_CODE;


-- ##JOIN�� ����3
-- 1. ��ȣ���� (CROSS JOIN)
-- 2. �������� (SELF JOIN)

-- 3. �������� �� �������� ���ι��� �ѹ��� ��� �� �� ����
SELECT EMP_NAME, DEPT_TITLE FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
-- ORA-00904: "LOCATION_ID":invalid identifier
-- **������ �߿��ϴ�**


--@�ǽ�����
-- 1. ������ �븮�̸鼭, ASIA ������ �ٹ��ϴ� ���� ��ȸ
-- ���, �̸� ,���޸�, �μ���, �ٹ�������, �޿��� ��ȸ�Ͻÿ�
SELECT EMP_ID AS ���, EMP_NAME AS �̸�
, JOB_NAME AS ���޸�, DEPT_TITLE AS �μ���
, LOCAL_NAME AS �ٹ�������, SALARY AS �޿� 
FROM EMPLOYEE
-- EMP-JOB �� EMP-DEPT �� DEPT-LOCA������ ����
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
-- WHERE JOB_NAME = '�븮' AND LOCAL_NAME IN ('ASIA1', 'ASIA2', 'ASIA3');
WHERE JOB_NAME = '�븮' AND LOCAL_NAME LIKE 'ASIA%';


--@���νǽ�����
--1. 2022�� 12�� 25���� ���� �������� ��ȸ�Ͻÿ�.
SELECT TO_CHAR(TO_DATE(20221225), 'day') "ũ��������" FROM DUAL;

--2. �ֹι�ȣ�� 1970��� ���̸鼭 ������ �����̰�, ���� ������ �������� �����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.
SELECT EMP_NAME AS �����, EMP_NO AS, DEPT_TITLE AS �μ���, JOB_NAME AS ���޸� FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 70 AND 79 
AND SUBSTR(EMP_NO,8,1) IN('2','4')
AND EMP_NAME LIKE '��%';

--3. �̸��� '��'�ڰ� ���� �������� ���, �����, �μ����� ��ȸ�Ͻÿ�.
SELECT EMP_ID AS ���, EMP_NAME AS �����, DEPT_TITLE AS �μ��� FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '%��%';

--5. �ؿܿ����ο� �ٹ��ϴ� �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.
SELECT EMP_NAME AS �����, JOB_NAME AS ���޸�, DEPT_ID AS �μ��ڵ�, DEPT_TITLE AS �μ��� FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE LIKE '�ؿܿ���_��';

--6. ���ʽ�����Ʈ�� �޴� �������� �����, ���ʽ�����Ʈ(null�̸� 0), �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
SELECT EMP_NAME AS �����, NVL(BONUS,0) AS ���ʽ�����Ʈ, DEPT_TITLE AS �μ���, LOCAL_NAME AS �ٹ������� FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL;

--7. �μ��ڵ尡 D2�� �������� �����, ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.
SELECT EMP_NAME AS �����, JOB_NAME AS ���޸�, DEPT_TITLE AS �μ���, LOCAL_NAME AS �ٹ������� FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE DEPT_ID = 'D2';

--8. �޿�������̺��� �ִ�޿�(MAX_SAL)���� ���� �޴� �������� �����, ���޸�, �޿�, ������ ��ȸ�Ͻÿ�.
-- (������̺�� �޿�������̺��� SAL_LEVEL�÷��������� ������ ��) -- ������ �������� ����


--9. �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� �����, �μ���, ������, �������� ��ȸ�Ͻÿ�.
SELECT EMP_NAME AS �����, DEPT_TITLE AS �μ���, LOCAL_NAME AS ������, NATIONAL_NAME AS ������ FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN('�ѱ�', '�Ϻ�')
ORDER BY 1 ASC;

--10. ���ʽ�����Ʈ�� ���� ������ �߿��� ������ ����� ����� �������� �����, ���޸�, �޿��� ��ȸ�Ͻÿ�. ��, join�� IN ����� ��
SELECT EMP_NAME AS �����, JOB_NAME AS ���޸�, SALARY AS �޿� FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE BONUS IS NULL AND JOB_NAME IN('����', '���');

--11. �������� ������ ����� ������ ���� ��ȸ�Ͻÿ�.
SELECT DECODE(ENT_YN, 'Y','����', 'N', '����') AS �ټӿ���, COUNT(*) AS ������
FROM EMPLOYEE
GROUP BY DECODE(ENT_YN, 'Y','����', 'N', '����');

