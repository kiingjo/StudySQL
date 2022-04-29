CREATE TABLE lprod(
    lprod_id number(5) not null,
    lprod_gu char(4) not null,
    lprod_nm varchar2(40) not null,
    constraint pk_lprod Primary key(lprod_gu)
);

-- ��ȸ�ϱ�
select * FROM LPROD;

-- ������ �Է��ϱ� (�Է� �� Ŀ�� �ʼ�!!!)
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    1,'P101','��ǻ����ǰ'
    );

insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    2,'P102','������ǰ'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    3,'P103','����ĳ���'
    );

insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    4,'P104','����ĳ���'
    );
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    5,'P105','������ȭ'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    6,'P106','ȭ��ǰ'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    7,'P107','����/CD'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    8,'P108','����'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    9,'P109','������'
    );
    

commit;

select * FROM LPROD;

--��ǰ �з��������� ��ǰ�з��ڵ��� ���� 
--P201�� �����͸� ��ȸ
SELECT * FROM lprod
    WHERE lprod_gu>'P102';--���ڷ� ���������� ������ ũ��� �ν��Ͽ� ���������
    
-- ��ǰ�з��ڵ尡 P102�� ���ؼ�
-- ��ǰ�з����� ���� ����� ������ �ּ���
-- ������ ����
select * from lprod
    where lprod_gu='P102';
    
update lprod
    Set lprod_nm='���'
where lprod_gu='P102'; --primarykey

select * from lprod;

--������ ����
-- ��ǰ�з������� P202�� ���� �����͸� ����
select * from lprod
    where lprod_gu = 'P102';
    
delete from lprod
    where lprod_gu='P102';

ROLLBACK; --Ŀ���� �������� ȿ�� X
commit; -- ������ ���̺� ���� �ϱ� ����

--���̺� ����
CREATE TABLE BUYER(
BUYER_ID    CHAR(6) NOT NULL,               --�ŷ�ó�ڵ�
BUYER_NAME  VARCHAR2(40)    NOT NULL,       --�ŷ�ó��
BUYER_IGU   CHAR(4) NOT NULL,               --��޻�ǰ ��з�
BUYER_BANK  VARCHAR2(60),                   --����
BUYER_BANKNO    VARCHAR2(60),               --���¹�ȣ
BUYER_BANKNAME  VARCHAR2(15),               --������
BUYER_ZIP   CHAR(7),                        --�����ȣ
BUYER_ADD1  VARCHAR2(100),                  --�ּ�1
BUYER_ADD2  VARCHAR2(70),                   --�ּ�2
BUYER_COMTEL    VARCHAR2(14) NOT NULL,      --��ȭ��ȣ
BUYER_FAX   VARCHAR2(20) NOT NULL           --FAX��ȣ
);

--���� �����ϱ�
ALTER TABLE BUYER ADD(             --�÷�(����) �߰��ϱ�
BUYER_MAIL VARCHAR2(60) NOT NULL,
BUYER_CHARGER VARCHAR2(20),
BUYER_TELEXT VARCHAR2(2)
);

--���� �Ӽ� �����ϱ�
ALTER TABLE BUYER MODIFY(BUYER_NAME VARCHAR(60));

ALTER TABLE BUYER
    ADD(CONSTRAINT PK_BUYER PRIMARY KEY(BUYER_ID),
        CONSTRAINT FR_BUYER_LPROD fOREIGN KEY(BUYER_IGU) --�θ�ã��
                                        REFERENCES LPROD(LPROD_GU));












