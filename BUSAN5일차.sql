/*상품분류명, 상품명, 상품색상, 매입수량, 주문수량, 거래처명을 주회
단, 상품분류코드 'P101' 'P201' 'P301' 인 것들에 대해 조회하고, 매입수량이 15이상인 것들과,
'서울'에 살고있는 회원 중에 생일이 1974년 생인 사람들에 대해 조회해 주세요.

정렬 회원아이디 기준 내림차순, 매입수량을 기준 내림차순
*/
--일반
SELECT P.PROD_LGU 상품분류명,
       P.PROD_NAME 상품명,
       P.PROD_COLOR 상품색상,
       BP.BUY_QTY 매입수량,
       C.CART_QTY 주문수량,
       B.BUYER_NAME 거래처명
FROM PROD P, BUYPROD BP, CART C ,BUYER B, MEMBER M
    WHERE M.MEM_ID=C.CART_MEMBER
   AND    C.CART_PROD=P.PROD_ID
   AND    P.PROD_ID=BP.BUY_PROD
   AND    P.PROD_BUYER=B.BUYER_ID
   AND      P.PROD_LGU IN ('P101','P201','P301')
   AND      BP.BUY_QTY >=15
   AND   SUBSTR(M.MEM_ADD1,1,2)='서울'
   AND   TO_CHAR(MEM_BIR,'YYYY')='1974' 
   
   ORDER BY MEM_ID DESC, BUY_QTY DESC ;
          
          
--국제표준
SELECT P.PROD_LGU 상품분류명,
       P.PROD_NAME 상품명,
       P.PROD_COLOR 상품색상,
       BP.BUY_QTY 매입수량,
       C.CART_QTY 주문수량,
       B.BUYER_NAME 거래처명
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
   AND   SUBSTR(M.MEM_ADD1,1,2)='서울'
   AND   TO_CHAR(MEM_BIR,'YYYY')='1974'
   
    ORDER BY MEM_ID DESC, BUY_QTY DESC;
---------------------------------------------------------------------------
--outer join
전체 분류의 상품자료수를 검색 조회
(분류코드, 분류명, 상품자료수)
1.분류테이블 조회
select * from lprod;

--2. 일반 join
select lprod_gu,
       lprod_nm,
       count(prod_lgu)
    from lprod,prod
    where lprod_gu=prod_lgu
    group by lprod_gu,lprod_nm;
    
3. outer join

--일반방식
select lprod_gu 분류코드,
       lprod_nm 분류명,
       count(prod_lgu) 상품자료수
    from lprod,prod
    where lprod_gu=prod_lgu(+) --(+)없는 쪽이 기준테이블 , (+)는 있으면 있는대로 없으면 없는대로 
    group by lprod_gu,lprod_nm
    order by lprod_gu; --prod_lgu 없는건 그냥 0으로 처리 즉 lprod 전체 테이블 나옴
    --lprod_gu는 부모테이블
    -- (+)가 갖다붙여준다라고 생각 
--국제방식
select lprod_gu 분류코드,
       lprod_nm 분류명,
       count(prod_lgu) 상품자료수
    from lprod LEFT OUTER JOIN prod --왼쪽테이블 전체 기준으로!
        ON  lprod_gu=prod_lgu 
    group by lprod_gu,lprod_nm
    order by lprod_gu;
    
    
-----------------예제--------------------------------------------------------

-- 전체상품의 2005년 1월 입고수량을 검색 조회
--상품코드 상품명 입고수량

--일반방식(사용하명 안된다)
SELECT PROD_ID 상품코드,
       PROD_NAME 상품명,
       SUM(BUY_QTY) 입고수량
        FROM PROD  BUYPROD(+)
    WHERE PROD_ID=BUY_PROD
    AND BUY_DATE BETWEEN '2005-01-01' AND '2005-01-31'
    GROUP BY PROD_ID, PROD_NAME;

--ANSI표준
SELECT PROD_ID 상품코드,
       PROD_NAME 상품명,
       SUM(NVL(BUY_QTY,0)) 입고수량
    FROM PROD LEFT OUTER JOIN  BUYPROD
                ON PROD_ID=BUY_PROD
    AND BUY_DATE BETWEEN '2005-01-01' AND '2005-01-31' --OUTER JOIN 일 경우 일반조건 WHERE절은 안쓴다.
    GROUP BY PROD_ID, PROD_NAME;
    
--------------예제
전체 회원의 2005년도 4월 구매현황 조회
회원ID, 성명, 구매수량의 합

SELECT MEM_ID,
       MEM_NAME,
       SUM(NVL(CART_QTY,0))
    FROM MEMBER LEFT OUTER JOIN CART
        ON MEM_ID=CART_MEMBER
            AND SUBSTR(CART_NO,1,6)='200504'
        GROUP BY MEM_ID, MEM_NAME
        ORDER BY MEM_ID, MEM_NAME;
        
-------------예제
--2005년도 월별 판매 현황을 검색
-- 판매월 판매수량 판매금액(판매수량*상품테이블의 판매가)

select TO_NUMBER(substr(CART_NO,5,2))|| '월' MM,
       SUM(CART_QTY) 판매수량 ,
       TO_CHAR(SUM(CART_QTY* PROD_SALE),'999,999,999,999') TOT
    FROM CART, PROD
        WHERE CART_PROD=PROD_ID
            AND SUBSTR(CART_NO,1,4)='2005'
        GROUP BY TO_NUMBER(substr(CART_NO,5,2))
        ORDER BY TO_NUMBER(substr(CART_NO,5,2));
        
-------------예제
/*
상품분류가 컴퓨터제품(P101)인 상품의 2005년도 일자별 판매조회
(판매일, 판매금액(5,000,000초과의 경우에만), 판매수량)
*/
SELECT  SUBSTR(CART_NO,1,8) 판매일,
        TO_CHAR(SUM(CART_QTY* PROD_SALE),'999,999,999,999') TOT,
         SUM(CART_QTY) 판매수량 
         
            FROM CART , PROD 
        WHERE CART_PROD=PROD_ID
        AND PROD_LGU = 'P101'
        AND CART_NO LIKE '2005%'
        GROUP BY SUBSTR(CART_NO,1,8)
        HAVING SUM(CART_QTY* PROD_SALE)>5000000
        ORDER BY SUBSTR(CART_NO,1,8)
        ;
        
----------------------------------------------------------------------------
-------------문제풀기---------------------------------------------------------

/*<태영>
김성욱씨는 주문했던 제품의 배송이 지연되어 불만이다.
구매처에 문의한 결과, 제품 공급에 차질이 생겨 배송이 늦어진다는 답변을 받았다.
김성욱씨는 해당 제품의 공급 담당자에게 직접 전화하여 항의하고 싶다.
어떤 번호로 전화해야 하는가?
*/
SELECT BUYER_COMTEL
FROM BUYER
    WHERE BUYER_ID IN (SELECT PROD_BUYER FROM PROD
                            WHERE PROD_ID IN (SELECT CART_PROD FROM CART
                                                WHERE CART_MEMBER IN (SELECT MEM_ID FROM MEMBER
                                                                        WHERE MEM_NAME='김성욱')
                                                                        )
                                                                        );
                                                                        
/* 쿼리 이어주는 과정
SELECT * FROM MEMBER
    WHERE MEM_NAME='김선욱';
                                                                        
SELECT * FROM CART
WHERE CART_MEMBER='u001';

SELECT * FROM PROD
WHERE PROD_ID IN('P102000004','P102000005');

SELECT * FROM BUYER
WHERE BUYER_ID IN('P10202');
*/

/*
<태경>
서울 외 타지역에 살며 외환은행을 사용하는 거래처 담당자가 담당하는 상품을 구매한 회원들의 이름, 생일을 조회 하며 
이름이 '이'로 시작하는 회원명을을 '리' 로 치환해서 출력해라 
*/
SELECT DECODE(SUBSTR(MEM_NAME,1,1),'이', '리' || SUBSTR(MEM_NAME,2), MEM_NAME) AS 이름,
       MEM_BIR
FROM MEMBER
    WHERE MEM_ID IN (SELECT CART_MEMBER FROM CART
                        WHERE CART_PROD IN (SELECT PROD_ID FROM PROD
                                                WHERE PROD_BUYER IN (SELECT BUYER_ID FROM BUYER
                                                                        WHERE BUYER_BANK='외환은행'
                                                                        AND SUBSTR(BUYER_ADD1,1,2) != '서울')
                                                                        )
                                                                    );
                                                                    
 /*                   
<덕현>
짝수 달에 구매된 상품들 중 세탁 주의가 필요 없는 상품들의 ID, 이름, 판매 마진을 출력하시오.
마진 출력 시 마진이 가장 높은 값은 10퍼센트 인하된 값으로, 가장 낮은 값은 10퍼센트 추가된 값으로 출력하시오.
정렬은 ID, 이름 순으로 정렬하시오.
(단, 마진은 소비자가 - 매입가로 계산한다.)
*/

SELECT PROD_ID 회원아이디,
       PROD_NAME 회원이름,
       DECODE( (PROD_PRICE-PROD_COST), (SELECT MAX(PROD_PRICE-PROD_COST) FROM PROD), (PROD_PRICE-PROD_COST)*0.9,
                                        (SELECT MIN(PROD_PRICE-PROD_COST) FROM PROD),  (PROD_PRICE-PROD_COST)*1.1, (PROD_PRICE-PROD_COST) ) AS 판매마진
         FROM PROD
        WHERE PROD_DELIVERY != '세탁 주의'
        AND PROD_ID IN (SELECT CART_PROD FROM CART
                            WHERE MOD(TO_NUMBER(SUBSTR(CART_NO,5,2)),2)=0
                            );

/*
[문제]
1. 
'여성캐주얼'이면서 제품 이름에 '여름'이 들어가는 상품이고, 
매입수량이 30개이상이면서 6월에 입고한 제품의
마일리지와 판매가를 합한 값을 조회하시오
Alias 이름,판매가격, 판매가격+마일리지
*/
SELECT PROD_NAME 상품이름,
       PROD_SALE 판매가격,
       PROD_SALE+prod_mileage AS 합가격
        FROM PROD
        WHERE  PROD_NAME LIKE '%여름%'
          AND  PROD_LGU IN (SELECT LPROD_GU FROM LPROD
                                WHERE LPROD_NM='여성캐주얼')
          AND PROD_ID IN (SELECT BUY_PROD FROM BUYPROD
                                WHERE buy_qty>=30
                                AND TO_CHAR(buy_date,'MM')='06')
                                ;
                                

/*
2. 
거래처 코드가 'P20' 으로 시작하는 거래처가 공급하는 상품에서 
제품 등록일이 2005년 1월 31일(2월달) 이후에 이루어졌고 매입단가가 20만원이 넘는 상품을
구매한 고객의 마일리지가 2500이상이면 우수회원 아니면 일반회원으로 출력하라
컬럼 회원이름과 마일리지, 우수 또는 일반회원을 나타내는 컬럼
*/
SELECT MEM_NAME 회원이름,
       MEM_MILEAGE 회원마일리지,
       CASE WHEN MEM_MILEAGE >=2500 THEN '우수회원'
            ELSE '일반회원' END AS 회원등급
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
6월달 이전(5월달까지)에 입고된 상품 중에 
배달특기사항이 '세탁 주의'이면서 색상이 null값인 제품들 중에 
판매량이 제품별 판매량의 평균보다 많이 팔린걸 구매한
김씨 성을 가진 손님의 이름과 보유 마일리지를 구하고 성별을 출력하시오
Alias 이름, 보유 마일리지, 성별
*/                        

SELECT MEM_NAME 회원이름,
       MEM_MILEAGE 보유마일리지,
       DECODE(SUBSTR(MEM_REGNO2,1,1),'1','남자',
                                     '2','여자') AS 성별
    FROM MEMBER
        WHERE SUBSTR(MEM_NAME,1,1)='김'
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
                                                    AND PROD_DELIVERY='세탁 주의'
                                                    AND PROD_ID IN (SELECT BUY_PROD FROM BUYPROD
                                                                        WHERE TO_CHAR(BUY_DATE,'MM') <'06')
                                                                        )
                                                                        );  
                                                                        
 /*
회원 이름과 회원별 총 구매 금액을 조회하여 내림차순으로 정렬하시오.
총 구매 금액은 천 단위로 끊고 원화 표시를 앞에 붙여 출력하시오.
*/
       SELECT  MEM_NAME 회원이름,
               TO_CHAR(SUM(CART_QTY* PROD_SALE),'L999,999,999') 
                AS 회원별_총구매금액
            FROM CART, PROD, MEMBER
                WHERE CART_PROD= PROD_ID
                AND  MEM_ID=CART_MEMBER
                    GROUP BY CART_MEMBER, MEM_NAME
                    ORDER BY SUM(CART_QTY* PROD_SALE) DESC;

Select  m.mem_name,
        TO_CHAR(sale.sum_sale, 'L999,999,999,999') AS 회원별_총구매금액
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



SELECT M.MEM_NAME 회원이름,
       TO_CHAR(SALE.SUM_SALE,'L999,999,999') AS 회원별_총구매금액
        
        FROM MEMBER M,
        (SELECT CART_MEMBER,
               SUM(CART_QTY *PROD_SALE) AS SUM_SALE
               FROM CART, PROD
                WHERE CART_PROD=PROD_ID
                GROUP BY CART_MEMBER
                ORDER BY CART_MEMBER) SALE
        WHERE M.MEM_ID=SALE.CART_MEMBER
        
    ORDER BY  SALE.SUM_SALE DESC;
               
                 

      
   
            
        
          