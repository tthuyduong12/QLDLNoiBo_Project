-- Truong don vi
-- Nhu mot nguoi dung co vai tro "Giang vien"
GRANT GIANGVIEN TO TRUONGDV;
GRANT SELECT, UPDATE (DIEMTHI, DIEMQT, DIEMCK, DIEMTK) ON DANGKY TO TRUONGDV;
-- Duoc xem du lieu phan cong giang day cua cac giang vien thuoc cac don vi ma minh lam truong
CREATE OR REPLACE VIEW VIEW_TRUONG_DV_PHANCONGGIANGDAY AS
SELECT * FROM PHANCONG WHERE MAGV IN (SELECT MANV FROM NHANSU WHERE MADV = 
                                     (SELECT MADV FROM DONVI 
                                      WHERE TRGDV= SYS_CONTEXT('USERENV', 'SESSION_USER')));

GRANT SELECT ON VIEW_TRUONG_DV_PHANCONGGIANGDAY TO TRUONGDV;
GRANT SELECT ON KHMO TO TRUONGDV;
/*
- Them, Xoa, Cap nhat du lieu tren PHANCONG, doi voi cac hp duoc phu trach
chuyen mon boi don vi ma mình lam truong. */
GRANT SELECT, INSERT, UPDATE, DELETE ON PHANCONG TO TRUONGDV;

/
GRANT EXECUTE ON PROC_DELETE_PHANCONG TO TRUONGDV;

/
GRANT EXECUTE ON PROC_INSERT_PHANCONG TO TRUONGDV;

/
GRANT EXECUTE ON PROC_UPDATE_PHANCONG TO TRUONGDV;