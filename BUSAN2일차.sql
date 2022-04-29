-- 2����

/* 
[����]
�� ���� ��ǰ�� ������ ���� ���� ȸ�� ���̵�, �̸��� ��ȸ 
*/
-- 1. ���̺� ã��        : ��ǰ - prod, ���ų��� - cart, ��ȸ�ϴ� �÷� - member (�ĺ�)
-- 2. ��ȸ�� �÷� ã�� : mem_id, mem_name (��ȸ�ϴ� �÷��� ����)
-- 3. ���� �ִ��� Ȯ�� : ���ų����� ���� �Ѵ� - cart
select mem_id ȸ��ID, mem_name ȸ����
from member 
-- ��ȸ�ϴ� �÷��� ����
where mem_id NOT IN (select cart_member from cart);

/*
[����]
�� ���� �Ǹŵ� ���� ���� ��ǰ�� ��ȸ�Ϸ��� �մϴ�.
�Ǹŵ� ���� ���� ��ǰ �̸��� ��ȸ�� �ּ���
*/
-- ���̺�    : prod, cart
-- ����       : 
-- ��ȸ�÷� : prod_name
select prod_name ��ǰ��
from prod
where prod_id NOT IN (select cart_prod from cart) ;

/*
[����]
ȸ�� �߿� ������ ȸ���� ���ݱ��� �����޴� ��� ��ǰ���� ��ȸ�� �ּ���.
*/
-- ���̺�    : ȸ�� - member, ��ǰ�� - prod, ���ų��� - cart
-- ����       : mem_name = '������'
-- ��ȸ�÷� : prod_name
-- 3���� ���̺� ���� ������谡 �ִ��� Ȯ���ϱ� (������ �ۼ� ����)
select prod_name ��ǰ��
from prod
where prod_id IN (
            select cart_prod 
            from cart
            where cart_member IN (
                        select mem_id
                        from member
                        where mem_name = '������'
                    )
        ) ;
        
/*
[����]
��ǰ �� �ǸŰ����� 10���� �̻�, 30���� ������ ��ǰ�� ��ȸ.
��ȸ �÷��� ��ǰ��, �ǸŰ����Դϴ�.
������ �ǸŰ����� �������� �������� ���ּ���.
*/
-- ���̺�    : prod, 
-- ����       :
-- ��ȸ�÷� : prod_name, prod_sale 
select prod_name, prod_sale
from prod
where prod_sale >= 100000 and 
         prod_sale <= 300000
order by prod_sale desc ;

select prod_name, prod_sale
from prod
where prod_sale BETWEEN 100000 and 300000 
order by prod_sale desc ;
-- BETWEEN : �̻�, ���� �� ���� ����� ���� (�̸�, �ʰ��� ���� ���x)

-- ȸ�� �� ���� 1975-01-01���� 1976-12-31 ���̿� �¾ ȸ���� �˻��Ͻÿ� (alias�� ȸ��ID, ȸ����, ����)
select mem_id ȸ��ID, mem_name ȸ����, mem_regno1 ����
from member
where mem_regno1 BETWEEN 750101 AND 761231 ;

select mem_id ȸ��ID, mem_name ȸ����, mem_regno1 ����
from member
where mem_bir BETWEEN '1975-01-01' 
                            AND '1976-12-31' ;
                            
select mem_id ȸ��ID, mem_name ȸ����, mem_regno1 ����
from member
where mem_bir BETWEEN '75/01/01' 
                            AND '76/12/31' ;
                            
/*
[����]
�ŷ�ó ����� ���������� ����ϴ� ��ǰ�� ������ ȸ������ ��ȸ�Ϸ��� �մϴ�.
ȸ�� ���̵�, ȸ�� �̸��� ��ȸ�� �ּ���
*/
-- 2���� ����� ����
-- ���̺�    : buyer, prod, cart, member, (lprod)
-- ����       : buyer_charger
-- ��ȸ�÷� : mem_id, mem_name
select mem_id, mem_name
from member
where mem_id IN (
            select cart_member 
            from cart
            where cart_prod IN (
                        select prod_id 
                        from prod
                        where prod_buyer IN (
                                    select buyer_id 
                                    from buyer
                                    where buyer_charger = '������'
                        )
            )
) ;

select mem_id, mem_name
from member
where mem_id IN (
            select cart_member 
            from cart
            where cart_prod IN (
                        select prod_id 
                        from prod
                        where prod_lgu IN (
                                    select lprod_gu 
                                    from lprod
                                    where lprod_gu IN (
                                                select buyer_lgu
                                                from buyer
                                                where buyer_charger = '������' 
                                    )
                        )
            )
) ;


-- LIKE


/*
[����]
ȸ�����̺��� ȸ������ �� ���� '��' --> '��' �� ġȯ�Ͽ� �ڿ� �̸��� ���� �� �˻�
alias���� ȸ����, ȸ����ġȯ
*/
select concat(replace(substr(mem_name, 1, 1), '��', '��'),
         substr(mem_name, 2))
from member ;


-- ��¥ �Լ�
select sysdate
from dual;

select add_months(sysdate, 5) 
from dual ;

select next_day(sysdate, '������'),
         last_day(sysdate)
from dual ;

-- �̹� ���� ��ĥ�� ���Ҵ��� �˻��ϱ�
select last_day(sysdate) - sysdate
from dual ;

-- ������ 3���� ȸ���� �˻�
select mem_bir, mem_name,
    extract(month from mem_bir) as bir3
from member
where extract(month from mem_bir) = '3' ; 

/*
ȸ�� ���� �� 1973����� �ַ� ������ ������ ������������ ��ȸ�Ϸ��� �մϴ�.
- ��ȸ�÷� : ��ǰ��
��, ��ǰ�� �Ｚ�� ���Ե� ��ǰ�� ��ȸ, �׸��� ��ȸ ����� �ߺ�����
*/
-- cart, member, prod
select DISTINCT prod_name
from prod
where prod_name LIKE '%�Ｚ%' 
   and prod_id IN (
                select cart_prod 
                from cart
                where cart_member IN (
                                select mem_id 
                                from member
                                where extract(year from mem_bir) = 1973
                                )
                    )
order by prod_name asc;

--��ǰ ���̺��� ��ǰ�԰����� '2008-09-28'�������� ������ �˻��Ͻÿ�
--(��ǰ��, ��ǰ�ǸŰ�, �԰���)

SELECT PROD_NAME,
       PROD_SALE,
       TO_CHAR(prod_insdate,'YYYY-MM-DD')
    FROM PROD ;
    
-- ȸ���̸��� ���Ϸ� ����ó�� ��µǰ� �ۼ��Ͻÿ�.
SELECT CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(MEM_NAME,'���� '),TO_CHAR(MEM_BIR,'YYYY')),'�� '),TO_CHAR(MEM_BIR,'MON') ),' ����̰� �¾ ������ '),TO_CHAR(MEM_BIR,'DAY'))
FROM MEMBER;

-- ���ڿ� ��ġ��� ||�� �ΰ��� ��ġ��
SELECT MEM_NAME ||
       '���� ' ||
       TO_CHAR(MEM_BIR,'YYYY') ||
       '�� ' ||
       TO_CHAR(MEM_BIR,'MON')|| 
       ' ����̰� �¾ ������ ' ||
       TO_CHAR(MEM_BIR,'DAY')
    FROM MEMBER;

SELECT TO_CHAR(1234.6,'999,999.00') FROM DUAL; --õ����, �Ҽ���ó��
SELECT TO_CHAR(-1234.6,'L9999.00PR') FROM DUAL; --���� ȭ��, �����ϰ�� <>����
SELECT TO_CHAR(255,'XXX') FROM DUAL;

SELECT TO_CHAR(PROD_SALE,'L999,999,999,999') �ǸŰ��� --õ����, ��ȭ
FROM PROD;

SELECT TO_NUMBER('3.14') FROM DUAL; --���ڰ��� ���� ���ڸ� TO_CHAR ����

SELECT MEM_ID ȸ��ID,
       CONCAT( SUBSTR(MEM_ID,1,2) ,
       TO_NUMBER(SUBSTR(MEM_ID,-2))+10) ����ȸ��ID
        FROM MEMBER
            WHERE MEM_NAME='�̻���';
    
-- �ǸŻ�ǰ���
SELECT PROD_LGU,  
       ROUND(AVG(PROD_COST),2) --���
        FROM PROD
        GROUP BY PROD_LGU;
 
--��ǰ�з��� �ǸŰ������       
SELECT PROD_LGU ��ǰ�з��ڵ�,
       TO_CHAR(AVG(PROD_SALE),'999,999,999,999') �ǸŰ������
    FROM PROD
        GROUP BY PROD_LGU;
        
--��ٱ��� ���̺��� ȸ���� COUNT ����
SELECT CART_MEMBER,
       COUNT(*) MEM_COUNT
FROM CART
GROUP BY CART_MEMBER;

SELECT MEM_ID,
       MEM_NAME
       FROM MEMBER
        WHERE MEM_ID IN (SELECT CART_MEMBER
                            FROM CART
                                 WHERE CART_QTY>= SELECT AVG(CART_QTY) FROM CART
                                )
                                ORDER BY mem_regno1;

SELECT AVG(CART_QTY) FROM CART;
        
SELECT MEM_ID,
       MEM_NAME
       FROM MEMBER
        WHERE MEM_ID IN (SELECT CART_MEMBER
                            FROM CART
                                WHERE CART_QTY >= (SELECT AVG(CART_QTY) FROM CART)
                                );
                                


