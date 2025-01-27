--VPD NHANSU

CREATE OR REPLACE FUNCTION VPD_NHANSU(P_SCHEMA VARCHAR2,P_OBJ VARCHAR2)
RETURN VARCHAR2
AS
    
    STR VARCHAR2(1000);
    USR VARCHAR(100);
BEGIN
    IF(UPPER(FUNC_VAITRO(USER))='NHANVIENCOBAN') THEN
        STR:='MANV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
        RETURN STR;
    ELSIF (UPPER(FUNC_VAITRO(USER))='GIANGVIEN') THEN
        STR:='MANV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
        RETURN STR;
    END IF;
    RETURN '1=1';
END;
/
BEGIN
    DBMS_RLS.DROP_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'NHANSU',
    POLICY_NAME =>'POL_NVCB_NHANSU'
    );
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'ADMINQL', 
        object_name     => 'NHANSU',   
        policy_name     => 'POL_NVCB_NHANSU',
        policy_function => 'VPD_NHANSU',
        STATEMENT_TYPES=>'SELECT,UPDATE'
    );
END;
/


--VPD DANG KY

--SELECT
CREATE OR REPLACE FUNCTION VPD_SELECT_DANGKY --(1)
    (P_SCHEMA VARCHAR2, P_OBJ VARCHAR2)
RETURN VARCHAR2 AS 
    STR VARCHAR2(1000);
    USR VARCHAR2(100); 
BEGIN
    IF(UPPER(FUNC_VAITRO(USER))='GIANGVIEN') THEN
        STR:='MAGV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
    ELSIF (UPPER(FUNC_VAITRO(USER))='TRUONGDV') THEN
        STR:='MAGV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
    ELSIF (UPPER(FUNC_VAITRO(USER))='SINHVIEN') THEN
        STR:='MASV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
    END IF;
    RETURN STR;
END;
/
BEGIN
DBMS_RLS.DROP_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'DANGKY',
    POLICY_NAME =>'POL_VPD_SELECT_DANGKY'
);
END;
/
BEGIN
DBMS_RLS.ADD_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'DANGKY',
    POLICY_NAME =>'POL_VPD_SELECT_DANGKY',
    POLICY_FUNCTION=>'VPD_SELECT_DANGKY',
    STATEMENT_TYPES=>'SELECT',
    UPDATE_CHECK => TRUE
 );
END;
/
--UPDATE
CREATE OR REPLACE FUNCTION VPD_UPDATE_DANGKY --(1)
    (P_SCHEMA VARCHAR2, P_OBJ VARCHAR2)
RETURN VARCHAR2 AS 
    STR VARCHAR2(1000);
    USR VARCHAR2(100); 
BEGIN
    IF(UPPER(FUNC_VAITRO(USER))='GIANGVIEN') THEN
        STR:='MAGV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
    ELSIF (UPPER(FUNC_VAITRO(USER))='TRUONGDV') THEN
        STR:='MAGV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
    END IF;
    RETURN STR;
END;
/
BEGIN
DBMS_RLS.DROP_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'DANGKY',
    POLICY_NAME =>'POL_VPD_UPDATE_DANGKY'
);
END;
/
BEGIN
DBMS_RLS.ADD_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'DANGKY',
    POLICY_NAME =>'POL_VPD_UPDATE_DANGKY',
    POLICY_FUNCTION=>'VPD_UPDATE_DANGKY',
    STATEMENT_TYPES=>'UPDATE',
    UPDATE_CHECK => TRUE
 );
END;
/
--INSERT,DELETE
CREATE OR REPLACE FUNCTION VPD_INSERT_DELETE_DANGKY(P_SCHEMA VARCHAR2, P_OBJ VARCHAR2)
RETURN VARCHAR2
AS
    STR VARCHAR2(1000);
    NAM_KHADUNG NUMBER;
    TIMESPACE NUMBER;
    YEAR1 VARCHAR2(4);
BEGIN
    -- L?Y N?M HI?N T?I
    SELECT EXTRACT(YEAR FROM SYSDATE) INTO NAM_KHADUNG FROM DUAL;
    -- T�NH TO�N KHO?NG TH?I GIAN T�NH T? NG�Y 1/5 C?A N?M HI?N T?I ??N NG�Y HI?N T?I
    SELECT TO_DATE('01-09-' || EXTRACT(YEAR FROM SYSDATE), 'DD-MM-YYYY') - SYSDATE INTO TIMESPACE FROM dual;
    --SELECT TO_DATE('01-09-' || EXTRACT(YEAR FROM SYSDATE), 'DD-MM-YYYY') - TO_DATE('15-04-' || EXTRACT(YEAR FROM SYSDATE), 'DD-MM-YYYY') FROM dual
    -- KH?I T?O GI� TR? M?C ??NH CHO STR
    STR := '';
    IF (UPPER(FUNC_VAITRO(USER)) = 'GIAOVU') THEN
        IF (TIMESPACE >= 14) THEN
            -- N?U TH?I GIAN C�N TRONG KHO?NG 14 NG�Y TR??C NG�Y 1/5
            STR := 'HK = 3 AND NAM >= ' || NAM_KHADUNG;
        ELSIF (TIMESPACE >= 138) THEN
            -- N?U TH?I GIAN ?� V??T QU� NG�Y 1/5
            STR := 'HK >= 2 AND NAM >= ' || NAM_KHADUNG;
        END IF;
    ELSIF (UPPER(FUNC_VAITRO(USER))='SINHVIEN') THEN
        YEAR1:=FUNC_YEAR();
            IF FUNC_DAY() < '15' THEN
                    IF FUNC_MONTH() = '1' THEN
                        RETURN 'HK=1 AND MASV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || ''' AND NAM= '||YEAR1;
                    ELSIF FUNC_MONTH() = '5' THEN
                        RETURN 'HK=2 AND MASV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || ''' AND NAM= '||YEAR1;
                    ELSIF FUNC_MONTH() = '9' THEN
                        RETURN 'HK=3 AND MASV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || ''' AND NAM= '||YEAR1;
                        END IF;
            END IF;
    END IF;
    RETURN STR;
END;
/

BEGIN
    DBMS_RLS.DROP_POLICY(
        object_schema   => 'ADMINQL', 
        object_name     => 'DANGKY',   
        policy_name     => 'POL_VPD_INSERT_DELETE_DANGKY'
    );
END;
/

BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema   => 'ADMINQL', 
        object_name     => 'DANGKY',   
        policy_name     => 'POL_VPD_INSERT_DELETE_DANGKY',
        policy_function => 'VPD_INSERT_DELETE_DANGKY',
        STATEMENT_TYPES => 'INSERT, DELETE',
        update_check => true
    );
END;
/
--VPD PHAN CONG
--SELECT
CREATE OR REPLACE FUNCTION VPD_SELECT_PHANCONG --(1)
    (P_SCHEMA VARCHAR2, P_OBJ VARCHAR2)
RETURN VARCHAR2 AS 
    STR VARCHAR2(1000);
    USR VARCHAR2(100); 
BEGIN
    IF UPPER(FUNC_VAITRO(USER)) = 'TRUONGDV' THEN
        STR := 'MAHP IN (SELECT MAHP FROM HOCPHAN WHERE MADV = (SELECT MADV FROM DONVI WHERE TRGDV = ''' || SYS_CONTEXT('USERENV', 'SESSION_USER') || '''))
               or MAGV IN (SELECT MANV FROM NHANSU WHERE MADV = (SELECT MADV FROM DONVI WHERE TRGDV= ''' || SYS_CONTEXT('USERENV', 'SESSION_USER') || '''))';
    ELSIF UPPER(FUNC_VAITRO(USER)) = 'GIANGVIEN' THEN
        STR := 'MAGV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
    END IF;
    RETURN STR;
END;
/
BEGIN
DBMS_RLS.DROP_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'PHANCONG',
    POLICY_NAME =>'POL_VPD_SELECT_PHANCONG'
);
END;
/
BEGIN
DBMS_RLS.ADD_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'PHANCONG',
    POLICY_NAME =>'POL_VPD_SELECT_PHANCONG',
    POLICY_FUNCTION=>'VPD_SELECT_PHANCONG',
    STATEMENT_TYPES=>'SELECT',
    UPDATE_CHECK => TRUE
 );
END;
/
--UPDATE
CREATE OR REPLACE FUNCTION VPD_UPDATE_PHANCONG --(1)
    (P_SCHEMA VARCHAR2, P_OBJ VARCHAR2)
RETURN VARCHAR2 AS 
    STR VARCHAR2(1000);
    USR VARCHAR2(100); 
BEGIN
    IF UPPER(FUNC_VAITRO(USER)) = 'TRUONGDV' THEN
        STR := 'MAHP IN (SELECT MAHP FROM HOCPHAN WHERE MADV = (SELECT MADV FROM DONVI 
                      WHERE TRGDV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''))';
    ELSIF(UPPER(FUNC_VAITRO(USER))='GIAOVU') THEN
        STR:='MAHP IN (SELECT MAHP FROM HOCPHAN WHERE MADV = ''VPK'')';
    ELSIF(UPPER(FUNC_VAITRO(USER))='TRUONGKHOA') THEN
        STR:='MAHP IN (SELECT MAHP FROM HOCPHAN WHERE MADV = ''VPK'')';
    ELSIF(UPPER(FUNC_VAITRO(USER))='GIANGVIEN') THEN
        STR:='MAGV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''';
    /*ELSIF (UPPER(FUNC_VAITRO(USER))='TRUONGDONVI') THEN 
        STR:='MAGV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || ''''; ???? */ 
    END IF;
    RETURN STR;
END;
/
BEGIN
DBMS_RLS.DROP_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'PHANCONG',
    POLICY_NAME =>'POL_VPD_UPDATE_PHANCONG'
);
END;
/
BEGIN
DBMS_RLS.ADD_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'PHANCONG',
    POLICY_NAME =>'POL_VPD_UPDATE_PHANCONG',
    POLICY_FUNCTION=>'VPD_UPDATE_PHANCONG',
    STATEMENT_TYPES=>'UPDATE',
    UPDATE_CHECK => TRUE
 );
END;

/
--insert delete
CREATE OR REPLACE FUNCTION VPD_INSERT_DELETE_PHANCONG --(1)
    (P_SCHEMA VARCHAR2, P_OBJ VARCHAR2)
RETURN VARCHAR2 AS 
    STR VARCHAR2(1000);
    USR VARCHAR2(100); 
BEGIN
    IF UPPER(FUNC_VAITRO(USER)) = 'TRUONGDV' THEN
        STR := 'MAHP IN (SELECT MAHP FROM HOCPHAN WHERE MADV = (SELECT MADV FROM DONVI 
                      WHERE TRGDV = ''' || SYS_CONTEXT('USERENV','SESSION_USER') || '''))';
    ELSIF(UPPER(FUNC_VAITRO(USER))='TRUONGKHOA') THEN
        STR:='MAHP IN (SELECT MAHP FROM HOCPHAN WHERE MADV = ''VPK'')';
    END IF;
    RETURN STR;
END;
/
BEGIN
DBMS_RLS.DROP_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'PHANCONG',
    POLICY_NAME =>'POL_VPD_INSERT_DELETE_PHANCONG'
);
END;
/
BEGIN
DBMS_RLS.ADD_POLICY(
    OBJECT_SCHEMA =>'ADMINQL',
    OBJECT_NAME=>'PHANCONG',
    POLICY_NAME =>'POL_VPD_INSERT_DELETE_PHANCONG',
    POLICY_FUNCTION=>'VPD_INSERT_DELETE_PHANCONG',
    STATEMENT_TYPES=>'INSERT, DELETE',
    UPDATE_CHECK => TRUE
 );
END;
/








