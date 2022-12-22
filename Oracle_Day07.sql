-- ## ��������(SubQuery)
-- �ϳ��� SQL���ȿ� ���ԵǾ��ִ� �Ǵٸ� SQL��(SELECT)
-- ���������� ���������� �����ϴ� �������� ����
-- ## Ư¡
-- ���������� ������ �����ʿ� ��ġ, �ݵ�� �Ұ�ȣ�� ������ ��(SELECT...)

-- ex1)������ ������ ������ �̸��� ����Ͻÿ�
-- step1)������ ������ ������ ID�� �����ΰ�?
SELECT MANAGER_ID FROM EMPLOYEE
WHERE EMP_NAME = '������';     -- 214
-- step1)������ ID�� ������ �̸��� ���Ѵ�.
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 214;
-- ���������� �ѹ���
SELECT EMP_NAME FROM EMPLOYEE 
WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '������');

-- ex2) �� ������ ��� �޿����� ���� �޿��� �ް� �ִ� ������ ���, �̸�, �����ڵ�, �޿��� ��ȸ�Ͻÿ�
-- step1) ��ձ޿� ���Ѵ�
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE;    -- 3047662
-- step1) ��ձ޿����� ���� �޿��� �޴� ������ ��ȸ�Ѵ�
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY > 3047662;
-- �ѹ���
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE);


-- ## ��������(SubQuery)�� ����
-- 1. ������ ��������
-- 2. ������ ��������
-- 3. ���߿� ��������
-- 4. ������ ���߿� ��������
-- 5. ��(ȣ��)�� ��������
-- 6. ��Į�� ��������
-- ## 1. ������ ��������
-- ���������� ��ȸ �����(��, Ʃ��, ���ڵ�)�� ������ 1�� �϶�
-- ## 2. ������ ��������
-- ���������� ��ȸ �����(��, Ʃ��, ���ڵ�)�� ������ �϶�
-- ������ �������� �տ��� �Ϲ� �񱳿����� ���Ұ� (IN/NOT IN, ANY, ALL, EXIST)
-- 2.1 IN
-- ������ �������� ��� �߿��� �ϳ��� ��ġ�ϴ� ��, OR
-- ex) �����⳪ �ڳ��� ���� �μ��� ���� ����� ���� ���
-- step1) ������ �μ��ڵ� ���ϰ� �ڳ��� �μ��ڵ� ���ϱ� 
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('������', '�ڳ���');  -- D9, D5
-- step2) ���� �μ��ڵ�� ���� ���
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE IN('D9', 'D5');
-- �ѹ���
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE IN(SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('������', '�ڳ���'));

--@�ǽ�����
-- 1. ���¿�, ������ ����� �޿����(emplyee���̺��� sal_level�÷�)�� ���� ����� ���޸�, ������� ���
SELECT JOB_NAME, EMP_NAME FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN(SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('���¿�', '������'));

-- 2. Asia1������ �ٹ��ϴ� ��� ���� ���, �μ��ڵ�, �����
-- �������� ���λ��
SELECT DEPT_CODE, EMP_NAME FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1';
-- �������� ���
SELECT DEPT_CODE AS �μ��ڵ�, EMP_NAME AS ����� FROM EMPLOYEE
WHERE DEPT_CODE IN(SELECT DEPT_ID FROM DEPARTMENT 
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1');

-- 2.2 NOT IN
-- ������ �������� ��� �߿��� �ϳ��� �������� �ʴ°�
--@�ǽ�����
-- ������ ��ǥ, �λ����� �ƴ� ��� ����� �μ����� ���
SELECT DEPT_CODE, EMP_NAME FROM EMPLOYEE
WHERE JOB_CODE NOT IN (SELECT JOB_CODE FROM JOB WHERE JOB_NAME IN('��ǥ', '�λ���'))
-- GROUP BY DEPT_CODE, EMP_NAME
ORDER BY 1;


-- ## 3. ���߿� ��������
-- ## 4. ������ ���߿� ��������
-- ## 5. ��(ȣ��)�� ��������
-- ���������� ���� ���������� �ְ� ���������� ������ ���� �� ����� �ٽ� ���������� ��ȯ�ؼ� ������
-- ���������� WHERE�� ������ ���ؼ��� ���������� ���� ����Ǵ� ������
-- �������� ���̺��� ���ڵ�(��)�� ���� ���������� ��� ���� �ٲ�
-- �����ϱ�! : ���������� �ִ°��� ���������� ������ ���� ��� ��������
-- �׷��� �ʰ� ���������� �ܵ����� ���Ǹ� �Ϲ� ��������
SELECT EMP_NAME, SALARY FROM EMPLOYEE
WHERE JOB_CODE = (SELECT JOB_CODE FROM JOB WHERE JOB_NAME = '��ǥ');

SELECT * FROM EMPLOYEE WHERE '1' = '2';

-- ���������� �Ѹ��̶� �ִ� ����, �Ŵ����� ����Ͻÿ�
SELECT EMP_NAME, EMP_ID, MANAGER_ID, SALARY FROM EMPLOYEE E
WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
SELECT DISTINCT MANAGER_ID FROM EMPLOYEE;

SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = 200;

-- DEPT_CODE�� ���� ����� ����Ͻÿ�
SELECT EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE IS NULL;
-- ������������ ������ ����ϴ� �ķ���? DEPT_CODE
-- �� ���� ��� ���̺��� ����ϴ°�? DEPARTMENT
SELECT EMP_NAME FROM EMPLOYEE E 
WHERE NOT EXISTS(SELECT 1 FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE);

-- ���� ���� �޿��� ��� ����� exists ��� ���������� �̿��ؼ� ���Ͻÿ�
SELECT EMP_NAME FROM EMPLOYEE E WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
SELECT EMP_NAME FROM EMPLOYEE E 
WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
-- ���� ���� �޿��� ��� ����� exists ��� ���������� �̿��ؼ� ���Ͻÿ�
SELECT EMP_NAME FROM EMPLOYEE E WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);
SELECT EMP_NAME FROM EMPLOYEE E 
WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);

-- ������ J1, J2, J3�� �ƴ� ����߿��� �ڽ��� �μ��� ��ձ޿����� ���� �޿��� �޴� ������.
-- �μ��ڵ�, �����, �޿�, �μ��� �޿����

-- ## 6. ��Į�� ��������
-- ������� 1���� ��� ��������, SELECT������ ����
-- ### 6.1 ��Į�� �������� - SELECT��
-- ex) ��� ����� ���, �̸�, �����ڻ��, �����ڸ��� ��ȸ�ϼ���
SELECT EMP_ID, EMP_NAME, MANAGER_ID
, (SELECT EMP_NAME FROM EMPLOYEE M WHERE M.EMP_ID = E.MANAGER_ID) 
FROM EMPLOYEE E;
--@�ǽ�����
--1. �����, �μ���, �μ��� ����ӱ��� ��Į�󼭺������� �̿��ؼ� ����ϼ���.
SELECT EMP_NAME AS �����, DEPT_TITLE AS �μ���
, (SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = D.DEPT_ID) "�μ��� ����ӱ�"
FROM EMPLOYEE
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID;

SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = 'D6';

-- ### 6.2 ��Į�� �������� - WHERE��
-- ex) �ڽ��� ���� ������ ��� �޿����� ���� �޴� ������ �̸�, ����, �޿��� ��ȸ�ϼ���

-- ### 6.3 ��Į�� �������� - ORDER BY��
-- ex) ��� ������ ���, �̸�, �ҼӺμ��� ��ȸ�� �μ����� ������������ �����ϼ���

-- ## 7. �ζ��� ��(FROM�������� ��������)
-- FROM���� ���������� ����� ���� �ζ��κ�(INLINE-VIEW)��� ��.
SELECT -- 2. ()
FROM   -- 3. ()
WHERE  -- 1. ()
ORDER BY;

-- ORA-00904: "LOCATION_ID": invalid identifier
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM(SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT);

-- ORA-00904: "MANAGER_ID": invalid identifier
SELECT EMP_ID, SALARY, MANAGER_ID
FROM(SELECT EMP_NAME, EMP_ID, SALARY, EMP_NO FROM EMPLOYEE);

-- ** VIEW��?
-- �������̺� �ٰ��� ������ ������ ���̺�(����ڿ��� �ϳ��� ���̺�ó�� ��밡���ϰ� ��)
-- *** VIEW�� ����
-- 1. Stored View : ���������� ��밡�� �� ����Ŭ ��ü
-- 2. Inline View : FROM���� ����ϴ� ��������, 1ȸ��

--@�ǽ�����
--1. employee���̺��� 2010�⵵�� �Ի��� ����� ���, �����, �Ի�⵵�� �ζ��κ並 ����ؼ� ���.
SELECT ���, �����, �Ի�⵵
FROM (SELECT EMP_ID AS ���, EMP_NAME AS �����, EXTRACT(YEAR FROM HIRE_DATE) AS �Ի�⵵
FROM EMPLOYEE)
-- WHERE (�Ի�⵵ - 2010) BETWEEN 0 AND 9;
WHERE �Ի�⵵ BETWEEN 2010 AND 2019;

--2. employee���̺��� ����� 30��, 40���� ���ڻ���� ���, �μ���, ����, ���̸� �ζ��κ並 ����ؼ� ����϶�.
SELECT *
FROM (SELECT EMP_ID AS ���
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE) AS �μ���
, DECODE(SUBSTR(EMP_NO,8,1), '1','��', '3','��','��') ����
-- 2022 - 1963 = 59
, EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS ����
FROM EMPLOYEE E)
--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID)
WHERE ���� = '��' AND FLOOR(����/10) IN (3, 4);


SELECT EMP_ID AS ���
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE) AS �μ���
, DECODE(SUBSTR(EMP_NO,8,1), '1','��', '3','��','��') ����
-- 2022 - 1963 = 59
, EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS ����
FROM EMPLOYEE E
WHERE DECODE(SUBSTR(EMP_NO,8,1), '1','��', '3','��','��') = '��' 
AND FLOOR((EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))))/10) IN (3, 4);

-- ##�������
-- ### 1. TOP-N�м�
-- ### 2. WITH
-- ### 3. ������ ����(Hierarchical Query)
-- ### 4. ������ �Լ�
-- #### 4.1 ���� �Լ�

-- ## JOIN�� ����3
-- 1. ��ȣ����(CROSS JOIN)
-- 2. ��������(SELF JOIN)

-- # ��������
-- ## 1. CHECK
-- ## 2. DEFAULT
