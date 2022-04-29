/*��ǰ�з���, ��ǰ��, ��ǰ����, ���Լ���, �ֹ�����, �ŷ�ó���� ��ȸ
��, ��ǰ�з��ڵ� 'P101' 'P201' 'P301' �� �͵鿡 ���� ��ȸ�ϰ�, ���Լ����� 15�̻��� �͵��,
'����'�� ����ִ� ȸ�� �߿� ������ 1974�� ���� ����鿡 ���� ��ȸ�� �ּ���.

���� ȸ�����̵� ���� ��������, ���Լ����� ���� ��������
*/
--�Ϲ�
SELECT P.PROD_LGU ��ǰ�з���,
       P.PROD_NAME ��ǰ��,
       P.PROD_COLOR ��ǰ����,
       BP.BUY_QTY ���Լ���,
       C.CART_QTY �ֹ�����,
       B.BUYER_NAME �ŷ�ó��
FROM PROD P, BUYPROD BP, CART C ,BUYER B, MEMBER M
    WHERE M.MEM_ID=C.CART_MEMBER
   AND    C.CART_PROD=P.PROD_ID
   AND    P.PROD_ID=BP.BUY_PROD
   AND    P.PROD_BUYER=B.BUYER_ID
   AND      P.PROD_LGU IN ('P101','P201','P301')
   AND      BP.BUY_QTY >=15
   AND   SUBSTR(M.MEM_ADD1,1,2)='����'
   AND   TO_CHAR(MEM_BIR,'YYYY')='1974' 
   
   ORDER BY MEM_ID DESC, BUY_QTY DESC ;
          
          
--����ǥ��
SELECT P.PROD_LGU ��ǰ�з���,
       P.PROD_NAME ��ǰ��,
       P.PROD_COLOR ��ǰ����,
       BP.BUY_QTY ���Լ���,
       C.CART_QTY �ֹ�����,
       B.BUYER_NAME �ŷ�ó��
FROM   MEMBER M INNER JOIN CART C
     ON     M.MEM_ID=C.CART_MEMBER
             INNER JOIN PROD P
     ON     C.CART_PROD=P.PROD_ID
             INNER JOIN BUYPROD BP
     ON     P.PROD_ID=BP.BUY_PROD
            INNER JOIN   BUYER B
     ON   P.PROD_BUYER=B.BUYER_ID
   AND      P.PROD_LGU IN ('P101','P201','P301')
   AND      BP.BUY_QTY >=15
   AND   SUBSTR(M.MEM_ADD1,1,2)='����'
   AND   TO_CHAR(MEM_BIR,'YYYY')='1974'
   
    ORDER BY MEM_ID DESC, BUY_QTY DESC;
---------------------------------------------------------------------------
--outer join
��ü �з��� ��ǰ�ڷ���� �˻� ��ȸ
(�з��ڵ�, �з���, ��ǰ�ڷ��)
1.�з����̺� ��ȸ
select * from lprod;

--2. �Ϲ� join
select lprod_gu,
       lprod_nm,
       count(prod_lgu)
    from lprod,prod
    where lprod_gu=prod_lgu
    group by lprod_gu,lprod_nm;
    
3. outer join

--�Ϲݹ��
select lprod_gu �з��ڵ�,
       lprod_nm �з���,
       count(prod_lgu) ��ǰ�ڷ��
    from lprod,prod
    where lprod_gu=prod_lgu(+) --(+)���� ���� �������̺� , (+)�� ������ �ִ´�� ������ ���´�� 
    group by lprod_gu,lprod_nm
    order by lprod_gu; --prod_lgu ���°� �׳� 0���� ó�� �� lprod ��ü ���̺� ����
    --lprod_gu�� �θ����̺�
    -- (+)�� ���ٺٿ��شٶ�� ���� 
--�������
select lprod_gu �з��ڵ�,
       lprod_nm �з���,
       count(prod_lgu) ��ǰ�ڷ��
    from lprod LEFT OUTER JOIN prod --�������̺� ��ü ��������!
        ON  lprod_gu=prod_lgu 
    group by lprod_gu,lprod_nm
    order by lprod_gu;
    
    
-----------------����--------------------------------------------------------

-- ��ü��ǰ�� 2005�� 1�� �԰������ �˻� ��ȸ
--��ǰ�ڵ� ��ǰ�� �԰����

--�Ϲݹ��(����ϸ� �ȵȴ�)
SELECT PROD_ID ��ǰ�ڵ�,
       PROD_NAME ��ǰ��,
       SUM(BUY_QTY) �԰����
        FROM PROD  BUYPROD(+)
    WHERE PROD_ID=BUY_PROD
    AND BUY_DATE BETWEEN '2005-01-01' AND '2005-01-31'
    GROUP BY PROD_ID, PROD_NAME;

--ANSIǥ��
SELECT PROD_ID ��ǰ�ڵ�,
       PROD_NAME ��ǰ��,
       SUM(NVL(BUY_QTY,0)) �԰����
    FROM PROD LEFT OUTER JOIN  BUYPROD
                ON PROD_ID=BUY_PROD
    AND BUY_DATE BETWEEN '2005-01-01' AND '2005-01-31' --OUTER JOIN �� ��� �Ϲ����� WHERE���� �Ⱦ���.
    GROUP BY PROD_ID, PROD_NAME;
    
--------------����
��ü ȸ���� 2005�⵵ 4�� ������Ȳ ��ȸ
ȸ��ID, ����, ���ż����� ��

SELECT MEM_ID,
       MEM_NAME,
       SUM(NVL(CART_QTY,0))
    FROM MEMBER LEFT OUTER JOIN CART
        ON MEM_ID=CART_MEMBER
            AND SUBSTR(CART_NO,1,6)='200504'
        GROUP BY MEM_ID, MEM_NAME
        ORDER BY MEM_ID, MEM_NAME;
        
-------------����
--2005�⵵ ���� �Ǹ� ��Ȳ�� �˻�
-- �Ǹſ� �Ǹż��� �Ǹűݾ�(�Ǹż���*��ǰ���̺��� �ǸŰ�)

select TO_NUMBER(substr(CART_NO,5,2))|| '��' MM,
       SUM(CART_QTY) �Ǹż��� ,
       TO_CHAR(SUM(CART_QTY* PROD_SALE),'999,999,999,999') TOT
    FROM CART, PROD
        WHERE CART_PROD=PROD_ID
            AND SUBSTR(CART_NO,1,4)='2005'
        GROUP BY TO_NUMBER(substr(CART_NO,5,2))
        ORDER BY TO_NUMBER(substr(CART_NO,5,2));
        
-------------����
/*
��ǰ�з��� ��ǻ����ǰ(P101)�� ��ǰ�� 2005�⵵ ���ں� �Ǹ���ȸ
(�Ǹ���, �Ǹűݾ�(5,000,000�ʰ��� ��쿡��), �Ǹż���)
*/
SELECT  SUBSTR(CART_NO,1,8) �Ǹ���,
        TO_CHAR(SUM(CART_QTY* PROD_SALE),'999,999,999,999') TOT,
         SUM(CART_QTY) �Ǹż��� 
         
            FROM CART , PROD 
        WHERE CART_PROD=PROD_ID
        AND PROD_LGU = 'P101'
        AND CART_NO LIKE '2005%'
        GROUP BY SUBSTR(CART_NO,1,8)
        HAVING SUM(CART_QTY* PROD_SALE)>5000000
        ORDER BY SUBSTR(CART_NO,1,8)
        ;
        
----------------------------------------------------------------------------
-------------����Ǯ��---------------------------------------------------------

/*<�¿�>
�輺���� �ֹ��ߴ� ��ǰ�� ����� �����Ǿ� �Ҹ��̴�.
����ó�� ������ ���, ��ǰ ���޿� ������ ���� ����� �ʾ����ٴ� �亯�� �޾Ҵ�.
�輺���� �ش� ��ǰ�� ���� ����ڿ��� ���� ��ȭ�Ͽ� �����ϰ� �ʹ�.
� ��ȣ�� ��ȭ�ؾ� �ϴ°�?
*/
SELECT BUYER_COMTEL
FROM BUYER
    WHERE BUYER_ID IN (SELECT PROD_BUYER FROM PROD
                            WHERE PROD_ID IN (SELECT CART_PROD FROM CART
                                                WHERE CART_MEMBER IN (SELECT MEM_ID FROM MEMBER
                                                                        WHERE MEM_NAME='�輺��')
                                                                        )
                                                                        );
                                                                        
/* ���� �̾��ִ� ����
SELECT * FROM MEMBER
    WHERE MEM_NAME='�輱��';
                                                                        
SELECT * FROM CART
WHERE CART_MEMBER='u001';

SELECT * FROM PROD
WHERE PROD_ID IN('P102000004','P102000005');

SELECT * FROM BUYER
WHERE BUYER_ID IN('P10202');
*/

/*
<�°�>
���� �� Ÿ������ ��� ��ȯ������ ����ϴ� �ŷ�ó ����ڰ� ����ϴ� ��ǰ�� ������ ȸ������ �̸�, ������ ��ȸ �ϸ� 
�̸��� '��'�� �����ϴ� ȸ�������� '��' �� ġȯ�ؼ� ����ض� 
*/
SELECT DECODE(SUBSTR(MEM_NAME,1,1),'��', '��' || SUBSTR(MEM_NAME,2), MEM_NAME) AS �̸�,
       MEM_BIR
FROM MEMBER
    WHERE MEM_ID IN (SELECT CART_MEMBER FROM CART
                        WHERE CART_PROD IN (SELECT PROD_ID FROM PROD
                                                WHERE PROD_BUYER IN (SELECT BUYER_ID FROM BUYER
                                                                        WHERE BUYER_BANK='��ȯ����'
                                                                        AND SUBSTR(BUYER_ADD1,1,2) != '����')
                                                                        )
                                                                    );
                                                                    
 /*                   
<����>
¦�� �޿� ���ŵ� ��ǰ�� �� ��Ź ���ǰ� �ʿ� ���� ��ǰ���� ID, �̸�, �Ǹ� ������ ����Ͻÿ�.
���� ��� �� ������ ���� ���� ���� 10�ۼ�Ʈ ���ϵ� ������, ���� ���� ���� 10�ۼ�Ʈ �߰��� ������ ����Ͻÿ�.
������ ID, �̸� ������ �����Ͻÿ�.
(��, ������ �Һ��ڰ� - ���԰��� ����Ѵ�.)
*/

SELECT PROD_ID ȸ�����̵�,
       PROD_NAME ȸ���̸�,
       DECODE( (PROD_PRICE-PROD_COST), (SELECT MAX(PROD_PRICE-PROD_COST) FROM PROD), (PROD_PRICE-PROD_COST)*0.9,
                                        (SELECT MIN(PROD_PRICE-PROD_COST) FROM PROD),  (PROD_PRICE-PROD_COST)*1.1, (PROD_PRICE-PROD_COST) ) AS �ǸŸ���
         FROM PROD
        WHERE PROD_DELIVERY != '��Ź ����'
        AND PROD_ID IN (SELECT CART_PROD FROM CART
                            WHERE MOD(TO_NUMBER(SUBSTR(CART_NO,5,2)),2)=0
                            );

/*
[����]
1. 
'����ĳ�־�'�̸鼭 ��ǰ �̸��� '����'�� ���� ��ǰ�̰�, 
���Լ����� 30���̻��̸鼭 6���� �԰��� ��ǰ��
���ϸ����� �ǸŰ��� ���� ���� ��ȸ�Ͻÿ�
Alias �̸�,�ǸŰ���, �ǸŰ���+���ϸ���
*/
SELECT PROD_NAME ��ǰ�̸�,
       PROD_SALE �ǸŰ���,
       PROD_SALE+prod_mileage AS �հ���
        FROM PROD
        WHERE  PROD_NAME LIKE '%����%'
          AND  PROD_LGU IN (SELECT LPROD_GU FROM LPROD
                                WHERE LPROD_NM='����ĳ�־�')
          AND PROD_ID IN (SELECT BUY_PROD FROM BUYPROD
                                WHERE buy_qty>=30
                                AND TO_CHAR(buy_date,'MM')='06')
                                ;
                                

/*
2. 
�ŷ�ó �ڵ尡 'P20' ���� �����ϴ� �ŷ�ó�� �����ϴ� ��ǰ���� 
��ǰ ������� 2005�� 1�� 31��(2����) ���Ŀ� �̷������ ���Դܰ��� 20������ �Ѵ� ��ǰ��
������ ���� ���ϸ����� 2500�̻��̸� ���ȸ�� �ƴϸ� �Ϲ�ȸ������ ����϶�
�÷� ȸ���̸��� ���ϸ���, ��� �Ǵ� �Ϲ�ȸ���� ��Ÿ���� �÷�
*/
SELECT MEM_NAME ȸ���̸�,
       MEM_MILEAGE ȸ�����ϸ���,
       CASE WHEN MEM_MILEAGE >=2500 THEN '���ȸ��'
            ELSE '�Ϲ�ȸ��' END AS ȸ�����
        FROM MEMBER
       WHERE MEM_ID IN (SELECT CART_MEMBER FROM CART
                            WHERE CART_PROD IN (SELECT PROD_ID FROM PROD
                                                    WHERE prod_cost> 200000
                                                      AND TO_NUMBER(TO_CHAR(prod_insdate,'MM'))>=2
                                                      AND  PROD_BUYER IN (SELECT BUYER_ID FROM BUYER
                                                                            WHERE BUYER_ID LIKE 'P20%')
                                                                            )
                                                                        );
                                                                        
/*                                                                       
3. 
6���� ����(5���ޱ���)�� �԰�� ��ǰ �߿� 
���Ư������� '��Ź ����'�̸鼭 ������ null���� ��ǰ�� �߿� 
�Ǹŷ��� ��ǰ�� �Ǹŷ��� ��պ��� ���� �ȸ��� ������
�达 ���� ���� �մ��� �̸��� ���� ���ϸ����� ���ϰ� ������ ����Ͻÿ�
Alias �̸�, ���� ���ϸ���, ����
*/                        

SELECT MEM_NAME ȸ���̸�,
       MEM_MILEAGE �������ϸ���,
       DECODE(SUBSTR(MEM_REGNO2,1,1),'1','����',
                                     '2','����') AS ����
    FROM MEMBER
        WHERE SUBSTR(MEM_NAME,1,1)='��'
        AND MEM_ID IN (SELECT CART_MEMBER FROM CART
                            WHERE cart_prod In ( select cart_prod
                                                    from cart
                                                    group by cart_prod
                                                    having sum(cart_qty) >= (select avg(sum(cart_qty))as avg_s
                                                                                         from cart
                                                                                        group by cart_prod
                                                                                                                )
                                                                                        )
                               AND CART_PROD IN (SELECT PROD_ID FROM PROD
                                                    WHERE PROD_COLOR IS NULL 
                                                    AND PROD_DELIVERY='��Ź ����'
                                                    AND PROD_ID IN (SELECT BUY_PROD FROM BUYPROD
                                                                        WHERE TO_CHAR(BUY_DATE,'MM') <'06')
                                                                        )
                                                                        );  
                                                                        
 /*
ȸ�� �̸��� ȸ���� �� ���� �ݾ��� ��ȸ�Ͽ� ������������ �����Ͻÿ�.
�� ���� �ݾ��� õ ������ ���� ��ȭ ǥ�ø� �տ� �ٿ� ����Ͻÿ�.
*/
       SELECT  MEM_NAME ȸ���̸�,
               TO_CHAR(SUM(CART_QTY* PROD_SALE),'L999,999,999') 
                AS ȸ����_�ѱ��űݾ�
            FROM CART, PROD, MEMBER
                WHERE CART_PROD= PROD_ID
                AND  MEM_ID=CART_MEMBER
                    GROUP BY CART_MEMBER, MEM_NAME
                    ORDER BY SUM(CART_QTY* PROD_SALE) DESC;

Select  m.mem_name,
        TO_CHAR(sale.sum_sale, 'L999,999,999,999') AS ȸ����_�ѱ��űݾ�
From member m, 
     (
        Select mem_id, 
        sum(cart_qty * prod_sale) as sum_sale
        From member, cart, prod
        Where mem_id = cart_member
          And cart_prod = prod_id
        Group by mem_id
     ) sale
Where m.mem_id = sale.mem_id
ORDER BY SALE.SUM_SALE DESC;



SELECT M.MEM_NAME ȸ���̸�,
       TO_CHAR(SALE.SUM_SALE,'L999,999,999') AS ȸ����_�ѱ��űݾ�
        
        FROM MEMBER M,
        (SELECT CART_MEMBER,
               SUM(CART_QTY *PROD_SALE) AS SUM_SALE
               FROM CART, PROD
                WHERE CART_PROD=PROD_ID
                GROUP BY CART_MEMBER
                ORDER BY CART_MEMBER) SALE
        WHERE M.MEM_ID=SALE.CART_MEMBER
        
    ORDER BY  SALE.SUM_SALE DESC;
               
                 

      
   
            
        
          