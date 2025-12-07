REPORT zemp_attendance. 

TABLES: zemp_track02. 

PARAMETERS: p_empid TYPE zemp_track02-zempid.

PARAMETERS:  r_login RADIOBUTTON GROUP g1 USER-COMMAND act DEFAULT 'X',  
             r_leave RADIOBUTTON GROUP g1. 
PARAMETERS:  p_login TYPE zemp_track02-emp_login, 
              p_ltype TYPE zemp_track02-emp_leave. 

DATA: p_date TYPE zemp_track02-zempdat, 
      lv_month TYPE char6. 

AT SELECTION-SCREEN OUTPUT. 
LOOP AT SCREEN.   
IF screen-name = 'P_LOGIN' OR screen-name = 'P_LTYPE'. 
  screen-active = 0. 
ENDIF. 

IF r_login = 'X' AND screen-name = 'P_LOGIN'. 
  screen-active = 1. 
ENDIF. 

IF r_leave = 'X' AND screen-name = 'P_LTYPE'. 
  screen-active = 1. 
ENDIF.
MODIFY SCREEN. 
ENDLOOP.  
 
AT SELECTION-SCREEN. 
IF r_login = 'X'. 
  p_login = sy-uzeit. 
ENDIF. 

START-OF-SELECTION.  
p_date = sy-datum.
lv_month = p_date+0(6).  
 
SELECT SINGLE zempid  FROM zmk_emp  WHERE zempid = @p_empid  INTO @DATA(lv_empid_chk). 

IF sy-subrc <> 0. 
  MESSAGE 'Employee does not exist in master table' TYPE 'E'. 
ENDIF.   

SELECT SINGLE *  FROM zemp_track02  WHERE zempid = @p_empid  AND zempdat = @p_date  INTO @DATA(ls_att). 
DATA(lv_exists) = xsdbool( sy-subrc = 0 ). 

IF r_login = 'X'.   
  IF lv_exists = abap_true AND ls_att-emp_status = 'L'.
    MESSAGE 'Leave already applied — cannot login' TYPE 'E'.  
  ENDIF.  
  IF lv_exists = abap_true AND ls_att-emp_login IS NOT INITIAL. 
    MESSAGE 'Already logged in today' TYPE 'E'. 
  ENDIF.  
  IF lv_exists = abap_true.
    UPDATE zemp_track02  SET emp_login = @p_login,  
    emp_status = 'P'  WHERE zempid = @p_empid AND zempdat = @p_date. 
  ELSE.  
    ls_att-zempid = p_empid. 
    ls_att-zempdat = p_date.  
    ls_att-emp_month = lv_month. 
    ls_att-emp_login = p_login. 
    ls_att-emp_status = 'P'.  
    INSERT zemp_track02 FROM ls_att.
  ENDIF.  
  MESSAGE |Login recorded at { p_login }. Status: Present| TYPE 'S'. 
ENDIF. 

IF r_leave = 'X'. 
  IF lv_exists = abap_true AND ls_att-emp_login IS NOT INITIAL. 
    MESSAGE 'Already logged in — leave cannot be marked' TYPE 'E'. 
  ENDIF.
  IF p_ltype IS INITIAL OR ( p_ltype <> 'S' AND p_ltype <> 'U' ).  
    MESSAGE 'Enter leave type S or U' TYPE 'E'. 
  ENDIF.  
  IF lv_exists = abap_true. 
    UPDATE zemp_track02  SET emp_status = 'L',
    emp_leave = @p_ltype  WHERE zempid = @p_empid AND zempdat = @p_date. 
  ELSE. 
    ls_att-zempid = p_empid. 
    ls_att-zempdat = p_date.
    ls_att-emp_month = lv_month. 
    ls_att-emp_status = 'L'. 
    ls_att-emp_leave = p_ltype. 
    INSERT zemp_track02 FROM ls_att.
  ENDIF. 
    MESSAGE |Leave recorded ({ p_ltype })| TYPE 'S'.  
ENDIF.   

SELECT COUNT(*)  FROM zemp_track02  WHERE zempid = @p_empid  AND emp_month = @lv_month  AND emp_status = 'P'  INTO @DATA(lv_total_present). 
UPDATE zemp_track02  SET total_present = @lv_total_present  WHERE zempid = @p_empid AND zempdat = @p_date.  

FORMAT COLOR COL_HEADING INTENSIFIED ON.
WRITE: / '===================== ATTENDANCE SUMMARY ====================='. 
FORMAT COLOR OFF. 

ULINE. 
WRITE: / ' EMPLOYEE ID : ', 
p_empid,  / ' ATTENDANCE DATE : ',
p_date,  / ' LOGIN / LEAVE TIME : ', 
COND string( WHEN r_login = 'X' THEN p_login ELSE '-' ), / ' LEAVE TYPE (IF ANY) : ', 
COND string( WHEN r_leave = 'X' THEN p_ltype ELSE '-' ),  / ' MARKED STATUS : ', 
COND string( WHEN r_login = 'X' THEN 'PRESENT' ELSE 'LEAVE' ),  / ' TOTAL PRESENT THIS MONTH : ',lv_total_present. 
ULINE. 

FORMAT COLOR COL_POSITIVE INTENSIFIED ON.
IF r_login = 'X'.
  WRITE: / '✔ Attendance marked successfully — Employee logged in.'. 
ELSE. 
  WRITE: / '✔ Leave marked successfully — Leave type recorded.'. 
ENDIF.

FORMAT COLOR OFF. 
WRITE: / '==============================================================='.
