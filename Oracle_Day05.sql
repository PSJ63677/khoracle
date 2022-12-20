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


--2. EMPLOYEE���̺��� ������ J1�� �����ϰ�,  �Ի�⵵�� �ο����� ��ȸ�ؼ�, �Ի�� �������� �������� �����ϼ���.

--3. [EMPLOYEE] ���̺��� EMP_NO�� 8��° �ڸ��� 1, 3 �̸� '��', 2, 4 �̸� '��'�� ����� ��ȸ�ϰ�,
-- ������ �޿��� ���(����ó��), �޿��� �հ�, �ο����� ��ȸ�� �� �ο����� ���������� ���� �Ͻÿ�

--4. �μ��� ���� �ο����� ���ϼ���.

--5. �μ��� �޿� ����� 3,000,000��(��������) �̻���  �μ��鿡 ���ؼ� �μ���, �޿������ ����ϼ���.
