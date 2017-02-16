# thdevelop_util_pkg
1.Download the file

2.Copy Paste into your schema were you want to use it or give a grant on it.

3.Use ist in your query
e.q : 

select empno,
       ename,
       hiredate,
       sal,
       comm,
       case when sal is not null then
           thdevelop_util_pkg.apex_item_button(p_item_label    => 'THDevelop'
                                               --p_attributes     IN    VARCHAR2 DEFAULT NULL,
                                               --p_item_id        IN    VARCHAR2 DEFAULT NULL,
                                               --p_item_class     IN    VARCHAR2 DEFAULT NULL,
                                               --p_onclick        IN    VARCHAR2 DEFAULT NULL
                                               )
           else 'No SAL' end as my_Button 
from emp

p_item_label label created for the button (NAME).
p_attributes Controls HTML tag attributes (such as disabled). p_item_id, p_item_class will overwrite
p_item_id HTML attribute ID. 
p_item_class HTML attribute CLASS.
p_onclick set the the on click function.

Have fun
