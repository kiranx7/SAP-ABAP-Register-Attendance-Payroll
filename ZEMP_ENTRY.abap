REPORT zemp_entry. 

TABLES: zmk_emp. 

PARAMETERS :  P_empnm TYPE zmk_emp-zname OBLIGATORY, 
              P_empage TYPE zmk_emp-age,  
              P_empgen TYPE zmk_emp-gender, 
              P_empgra TYPE zmk_emp-graphic_id,  
              P_empsal TYPE zmk_emp-salary, 
              P_empsu TYPE zmk_emp-salary_unit. 

DATA : wa_emp TYPE zmk_emp, 
       lv_max TYPE zmk_emp-zempid, 
       lv_check TYPE zmk_emp-zempid.

START-OF-SELECTION. 

wa_emp-zname = P_empnm.
wa_emp-age = P_empage. 
wa_emp-gender = P_empgen. 
wa_emp-graphic_id = P_empgra.
wa_emp-salary = P_empsal. 
wa_emp-salary_unit = P_empsu.

SELECT MAX( zempid ) INTO lv_max FROM zmk_emp.

wa_emp-zempid = lv_max + 1.

WRITE lv_max. 

SELECT SINGLE zempid FROM zmk_emp INTO lv_check WHERE zname = P_empnm . 

IF lv_check IS NOT INITIAL.  
  MESSAGE 'The employee name already exists' TYPE 'E'. 
ELSE.  
  INSERT zmk_emp FROM wa_emp.  ENDIF.
