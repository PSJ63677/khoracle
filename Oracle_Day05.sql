-- Oracle day05
-- �׷��Լ�
-- �������� ���� ���� �� ���� ����� ������ �Լ�
-- SUM, AVG, COUNT, MAX, MIN

--@�ǽ�����
--1. [EMPLOYEE] ���̺��� ���� ����� �޿� �� ���� ���
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999,999') "�޿� �� ��"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 1;

--2. [EMPLOYEE]���̺��� �μ��ڵ尡 D5�� ������ ���ʽ� ���� ������ ���
SELECT TO_CHAR(SUM(SALARY*12+SALARY*NVL(BONUS,0)), 'L999,999,999,999') "����"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--3. [EMPLOYEE] ���̺��� �� ����� ���ʽ� ����� �Ҽ� ��°¥������ �ݿø��Ͽ� ���Ͽ���
SELECT ROUND(AVG(NVL(BONUS,0)),2)
FROM EMPLOYEE;

--4. [EMPLOYEE] ���̺��� D5 �μ��� ���� �ִ� ����� ���� ��ȸ
SELECT COUNT(EMP_NAME) "����� ��",  COUNT(*) "����"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
-- ex) EMPLOYEE���̺� ����� �������� ���� ���Ͻÿ�
SELECT COUNT(*)
FROM EMPLOYEE;

--5. [EMPLOYEE] ���̺��� ������� �����ִ� �μ��� ���� ��ȸ (NULL�� ���ܵ�)
SELECT COUNT(DISTINCT DEPT_CODE) "�μ��� ��"
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

--6. [EMPLOYEE] ���̺��� ��� �� ���� ���� �޿��� ���� ���� �޿��� ��ȸ
SELECT MAX(SALARY), MIN(SALARY) FROM EMPLOYEE;

--7. [EMPLOYEE] ���̺��� ���� ������ �Ի��ϰ� ���� �ֱ� �Ի����� ��ȸ�Ͻÿ�
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE) FROM EMPLOYEE;


-- # GROUP BY��
-- ������ �׷� �������� ����� �׷��Լ��� ���Ѱ��� ������� �����ϱ� ������
-- �׷��Լ��� �̿��Ͽ� �������� ������� �����ϱ� ���ؼ���
-- �׷��Լ��� ����� �׷��� ������ GROUP BY���� ����Ͽ� ����ؾ� ��.
-- ex)
-- not a GROUP BY expression
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;
--GROUP BY DEPT_CODE;
-- ORA-00937: not a single-group group function

-- ���޺� �޿��հ踦 ���غ��ÿ�
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

--[EMPLOYEE] ���̺��� �μ��ڵ� �׷캰 �޿��� �հ�, �׷캰 �޿��� ���(����ó��),
-- �ο����� ��ȸ�ϰ�, �μ��ڵ� ������ ����
SELECT DEPT_CODE, SUM(SALARY), FLOOR(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE;

--[EMPLOYEE] ���̺��� �μ��ڵ� �׷캰, ���ʽ��� ���޹޴� ��� ���� ��ȸ�ϰ� �μ��ڵ� ������ ����
-- BONUS�÷��� ���� �����Ѵٸ�, �� ���� 1�� ī����.
-- ���ʽ��� ���޹޴� ����� ���� �μ��� ����.
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
--WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY 1;
-- FROM �� WHERE �� GROUP BY �� SELECT �� ORDER BY


--@�ǽ�����
--1. EMPLOYEE ���̺��� ������ J1�� �����ϰ�, ���޺� ����� �� ��ձ޿��� ����ϼ���.
SELECT JOB_CODE, COUNT(JOB_CODE), AVG(SALARY)
FROM EMPLOYEE
WHERE JOB_CODE <> 'J1'
-- WHERE JOB_CODE != 'J1
GROUP BY JOB_CODE;

--2. EMPLOYEE���̺��� ������ J1�� �����ϰ�, �Ի�⵵�� �ο����� ��ȸ�ؼ�, �Ի�� �������� �������� �����ϼ���.
SELECT EXTRACT(YEAR FROM HIRE_DATE) COUNT(*)
FROM EMPLOYEE
WHERE JOB_CODE <> 'J1'
ORDER BY EXTRACT(YEAR FROM HIRE_DATE)
GROUP BY 1 ASC;
-- 1�� �÷��� ���� ��������

--3. [EMPLOYEE] ���̺��� EMP_NO�� 8��° �ڸ��� 1, 3 �̸� '��', 2, 4 �̸� '��'�� ����� ��ȸ�ϰ�,
-- ������ �޿��� ���(����ó��), �޿��� �հ�, �ο����� ��ȸ�� �� �ο����� ���������� ���� �Ͻÿ�
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��') "����"
, FLOOR(AVG(SALARY)), SUM(SALARY), COUNT(*) "�ο���"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��')
ORDER BY 4 DESC;
-- ORDER BY "�ο���" DESC;

--4. �μ��� ���� �ο����� ���ϼ���.
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��') "����", COUNT(*) "�ο���"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��');

--5. �μ��� �޿� ����� 3,000,000��(��������) �̻���  �μ��鿡 ���ؼ� �μ���, �޿������ ����ϼ���.
SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;
HAVING FLOOR(AVG(SALARY)) >= 3000000;

-- # HAVING��
-- �׷��Լ��� ���� ���ؿ� �׷쿡 ���� ������ �����Ҷ��� HAVING���� ����� (WHERE�� ���Ұ�)


--@�ǽ�����
--1. �μ��� �ο��� 5���� ���� �μ��� �ο����� ����ϼ���.
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(*) > 5;

--2. �μ����� ���޺� �ο����� 3���̻��� ������ �μ��ڵ�, �����ڵ�, �ο����� ����ϼ���.
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(*) >= 3;
ORDER BY 1 DESC;

--3. �����ϴ� ����� 2�� �̻��� �Ŵ��� ���̵�� �����ϴ� ������� ����ϼ���.
SELECT EMP_NAME, MANAGER_ID
FROM EMPLOYEE
GROUP BY MANAGER_ID
HAVING COUNT(*) >= 2 AND MANAGER_ID IS NOT NULL
ORDER BY 1;

