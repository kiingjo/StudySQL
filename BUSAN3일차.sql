
                
-- 3����
/*
���� ����
 : select -> from + ���̺� -> where + �Ϲ� ���� (in, and, or, ..) (�´� ���ǵ��� �ɷ���)
   -> group by + �Ϲ��÷� -> having + �׷� ���� 
   -> (select ��) ����� �÷�(�׷� �Լ�) üũ -> order by 
*/

-- GROUP
-- count
-- count(�÷�) : null ���� ����
-- count(*)     : null ���� ����

/*
[����] 
���ų���(��ٱ���) �������� ȸ�����̵�� �ֹ�(����)�� ���� ����� ��ȸ�� �ּ���.
ȸ�����̵� �������� ��������
*/
select cart_member, avg(cart_qty) as avg_qty
from cart 
group by cart_member
order by cart_member desc;

/*
[����]
��ǰ �������� �ǸŰ����� ��� ���� �����ּ���.
��, ��հ��� �Ҽ��� ��°�ڸ����� ǥ�����ּ���.
*/
select round(avg(prod_sale), 2) avg_sale
from prod ;

/*
[����]
��ǰ�������� ��ǰ�з��� �ǸŰ����� ��հ��� �����ּ���.
��ȸ �÷��� ��ǰ�з��ڵ�, ��ǰ�з��� �ǸŰ����� ���
��, ��հ��� �Ҽ��� ��°�ڸ����� ǥ�����ּ���.
*/
select prod_lgu, round(avg(prod_sale), 2) avg_sale
from prod
group by prod_lgu;

-- ȸ�����̺��� ����������� count ����
select count(DISTINCT mem_like) ���������
from member ;

-- ȸ�����̺��� ��̺� count����
select mem_like ���, 
         count(mem_like) �ڷ��, count(*) "�ڷ��(*)"
from member
group by  mem_like ;

-- ȸ�����̺��� ������������ count����
select count(DISTINCT mem_job) kind_job
from member ;

select mem_id, count(mem_job) cnt_job
from member 
group by mem_id
order by ;

/*
[����]
ȸ�� ��ü�� ���ϸ��� ��պ��� ū ȸ���� ���� ���̵�, �̸�, ���ϸ����� ��ȸ�� �ּ���
������ ���ϸ����� ���� ������
*/
select avg(mem_mileage)
from member ;

select mem_id, mem_name, mem_mileage 
from member
where mem_mileage >= (
                                  select avg(mem_mileage)
                                  from member
                                  )
order by mem_mileage desc;


-- max(col), min(col)
select cart_member ȸ��ID,
        max(distinct cart_qty) "�ִ����(distinct)",
        max(cart_qty) �ִ����
from cart
group by cart_member ;


select *
from cart ;

-- ������ 2005�⵵ 7�� 11���̶� �����ϰ� ��ٱ������̺� �߻��� �߰��ֹ���ȣ�� �˻��Ͻÿ�
-- alias �ְ�ġ�ֹ���ȣ, �߰��ֹ���ȣ
select max(cart_no) �������ֹ���ȣ, (max(cart_no) + 1) �߰��ֹ���ȣ 
from cart
where cart_no LIKE '20050711%' ;
-- like / substr / to_date �� ��� ����

/*
[����]
������������ �������� �Ǹŵ� ��ǰ�� ����, ��ձ��ż����� ��ȸ�Ϸ��� �մϴ�.
������ ������ �������� �����������ּ���
*/
select substr(cart_no, 1, 4) as yyyy, 
         sum(cart_qty) as sum_qty,
         avg(cart_qty) as avg_qty
from cart 
group by substr(cart_no, 1, 4)
order by yyyy desc;
-- ���� �׷��� �׷� �Լ��� �ƴϴ� : �׷��Լ��� ������ �Ϲ��Լ��� ���ִٶ�� ��

/*
[����]
������������ ������, ��ǰ�з��ڵ庰�� ��ǰ�� ������ ��ȸ�Ϸ��� �մϴ�.
������ ������ �������� �����������ּ���.
*/
SELECT SUBSTR(CART_NO,1,4) YYYY,
       SUBSTR(CART_PROD,1,4) ��ǰ�з��ڵ�,
       COUNT(CART_PROD) ����
        FROM CART
            GROUP BY SUBSTR(CART_NO,1,4), SUBSTR(CART_PROD,1,4)
                ORDER BY SUBSTR(CART_NO,1,4);
                
SELECT AVG(mem_mileage) MEM_AVG,
       SUM(MEM_MILEAGE) MEM_SUM,
       MAX(MEM_MILEAGE) MEM_MAX,
       MIN(MEM_MILEAGE) MEM_MIN,
       COUNT(MEM_ID)
  FROM MEMBER;
  
/*
��ǰ ���̺��� ��ǰ �з��� �ǸŰ���ü�� 
���, �հ�, �ְ�, ������, �ڷ�� �˻�
*/

SELECT PROD_LGU ��ǰ�ڵ�,
       ROUND(AVG(PROD_SALE),2) ���,
       SUM(PROD_SALE) �հ�,
       MAX(PROD_SALE) �ִ밪,
       MIN(PROD_SALE) �ּҰ�,
       COUNT(PROD_LGU) �ڷ��
    FROM PROD
        GROUP BY PROD_LGU
        HAVING COUNT(PROD_LGU) >=20 ; --�׷�ȭ������ ������ HAVING
        
/*
ȸ�����̺��� ����(�ּ�1�� 2�ڸ�), ���ϳ⵵���� ���ϸ������,
�հ�,�ְ�,�ּ�, �ڷ�� �˻�
*/

SELECT SUBSTR(MEM_ADD1,1,2) ����,
       TO_NUMBER(SUBSTR(MEM_BIR,1,2)) �⵵, --TO_CHAR(MEM_BIR, 'YYYY')
       AVG(mem_mileage) MEM_AVG,
       SUM(MEM_MILEAGE) MEM_SUM,
       MAX(MEM_MILEAGE) MEM_MAX,
       MIN(MEM_MILEAGE) MEM_MIN,
       COUNT(MEM_MILEAGE)
    FROM MEMBER
            GROUP BY  SUBSTR(MEM_ADD1,1,2),
                      TO_NUMBER(SUBSTR(MEM_BIR,1,2))
                        ORDER BY SUBSTR(MEM_ADD1,1,2), 
                                 TO_NUMBER(SUBSTR(MEM_BIR,1,2));
UPDATE BUYER SET BUYER_CHARGER=NULL
WHERE BUYER_CHARGER LIKE '��%';

UPDATE BUYER SET BUYER_CHARGER=''
    WHERE BUYER_CHARGER LIKE '��%';
        
SELECT BUYER_NAME �ŷ�ó,
       BUYER_CHARGER �����,
        FROM BUYER
            WHERE BUYER_CHARGER = NULL;

SELECT BUYER_NAME �ŷ�ó,
       BUYER_CHARGER �����,
        FROM BUYER
            WHERE BUYER_CHARGER = NULL;
            
SELECT BUYER_NAME,
       BUYER_CHARGER,
       NVL(BUYER_CHARGER,'����')
        FROM BUYER;
        
SELECT MEM_NAME ����,
       MEM_MILEAGE ���ϸ���,
       MEM_MILEAGE +100 ���ϸ���_100
    FROM MEMBER;

SELECT MEM_NAME ����,
       MEM_MILEAGE ���ϸ���,
       NVL2(MEM_MILEAGE,'����ȸ��','������ ȸ��') ȸ������
    FROM MEMBER;
    
SELECT DECODE(SUBSTR(PROD_LGU,1,2),
              'P1','��ǻ��/������ǰ',
              'P2','�Ƿ�',
              'P3','��ȭ','��Ÿ')
        FROM PROD;
        
SELECT  PROD_NAME ��ǰ��,
        PROD_LGU  ��ǰ�ڵ�,
        DECODE(SUBSTR(PROD_LGU,1,2),
              'P1',PROD_SALE*1.1,
              'P2',PROD_SALE*1.15,PROD_SALE) AS ��ǰ��_�λ󰡰�
        FROM PROD;

CASE �÷�  

WHEN ����1 THEN ��1 

WHEN ����2 THEN ��2 

ELSE ��3 

END 

SELECT MEM_NAME,
       (MEM_REGNO1 || '-' || MEM_REGNO2) �ֹε�Ϲ�ȣ,
       CASE SUBSTR(MEM_REGNO2,1,1) WHEN '1' THEN '����'
                                    ELSE '����' 
                                    END    --CASE���� END �ʼ�
                                    AS ����
    FROM MEMBER;
    
----------------------���� �����----------------------------------------
/*
����1
��ǻ����ǰ�� �ְ��ϸ� ������(����,��õ)�� ��� �ּҿ� '��' �� �� ���� ��� ����ڰ� ����ϴ�
��ǰ �߿��� �ǸŰ����� ��ü�ǸŰ��� �̻��� ��ǰ�� ������ ȸ������ ��� ��(����)��  �з��ϰ�

������ ȸ������ �����ϴ� ����Ϻ� ���� ���� ������� ������� �˾Ƴ��ÿ�
--����: ������
--�泲, ���� : ��û�� �������� ���
*/

select DECODE(SUBSTR(MEM_ADD1,1,2),'����','������',
                                   '�泲','��û��',
                                   '����','��û��','���') AS ����,
       MEM_MEMORIAL,
       COUNT(MEM_MEMORIAL)
      
                                   
        from member
where mem_id IN (
            select cart_member 
            from cart
            where cart_prod IN (
                        select prod_id  
                        from prod
                        where PROD_SALE >= (SELECT AVG(PROD_SALE) FROM PROD) 
                            AND prod_lgu IN (
                                    select lprod_gu 
                                    from lprod
                                    where LPROD_NM='��ǻ����ǰ'
                                        AND lprod_gu IN (
                                                select buyer_lgu
                                                from buyer
                                                where SUBSTR(BUYER_ADD1,1,2)='����' 
                                                OR    SUBSTR(BUYER_ADD1,1,2)='��õ'
                                                AND   BUYER_ADD1 LIKE '%��%'  
                                    )
                        )
            )
)

GROUP BY  MEM_MEMORIAL, 
          DECODE(SUBSTR(MEM_ADD1,1,2),'����','������',
                                   '�泲','��û��',
                                   '����','��û��','���') ;

------------------------------------------------------------------------     


/*
�λ꿡 ��� ����ڰ� ����ϴ� ��ǰ�� �ǸŰ��� ��ü ����ǸŰ��� 3�� �̻��̰� 
���� �������� ���������� ���� ���� ��ǰ�� ������ ȸ�� �� �ڿ����� �ƴ� ��� ���̵�� ȸ���̸���
���Ͻÿ�
*/


                        
                        
                        
        
                        
                        
                        
                        
                        
                        
                        
                        
                        
     