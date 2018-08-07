  create or replace package thdevelop_util_pkg 
  as
  /**
  * Give a HTML for Redering a Button
  * @param p_item_label label created for the button (NAME).
  * @param p_attributes Controls HTML tag attributes (such as disabled). p_item_id, p_item_class will overwrite
  * @param p_item_id HTML attribute ID. 
  * @param p_item_class HTML attribute CLASS.
  * @param p_onclick set the the on click function.
  */
  function apex_item_button(p_item_label     IN    VARCHAR2,
                            p_attributes     IN    VARCHAR2 DEFAULT NULL,
                            p_item_id        IN    VARCHAR2 DEFAULT NULL,
                            p_item_class     IN    VARCHAR2 DEFAULT NULL,
                            p_onclick        IN    VARCHAR2 DEFAULT NULL
                           )
  return varchar2; 

  /**
  * Get the PDF File from the Database to the application
  * @param pi_pdf_id_column name of the pk column
  * @param pi_filename_column name of the filename column
  * @param pi_bolb_column name of the blob column
  * @param pi_tablename name of the table where the blobs (PDF) is save
  * @param pi_pdf_id PK of the pdf that will be render in the region
  */
  procedure get_preview(pi_pdf_id_column in varchar2,
                        pi_filename_column in varchar2,
                        pi_bolb_column in varchar2,
                        pi_tablename in varchar2,
                        pi_pdf_id in number,
                        pi_sql_statement in varchar2 default null
                       );

  end thdevelop_util_pkg;
  /

  create or replace package body thdevelop_util_pkg 
  as
  function apex_item_button(p_item_label     IN    VARCHAR2,
                            p_attributes     IN    VARCHAR2 DEFAULT NULL,
                            p_item_id        IN    VARCHAR2 DEFAULT NULL,
                            p_item_class     IN    VARCHAR2 DEFAULT NULL,
                            p_onclick        IN    VARCHAR2 DEFAULT NULL
                           )
  return varchar2
  as
  l_return varchar2(32767);
  begin
    l_return := q'[<button type="button" ]';
    
    if p_attributes is null then
     
      if p_onclick is not null then
        l_return := l_return || q'[onclick="]' || p_onclick || q'[" ]';
      end if;
     
      if p_item_class is not null then
        l_return := l_return || q'[class="t-Button ]' || p_item_class || q'[" ]';
      else
        l_return := l_return || q'[class="t-Button" ]' ;
      end if;
  
      if p_item_id is not null then
        l_return := l_return || q'[id="]' || p_item_id || q'["]';
      end if;
    else
      l_return := l_return || p_attributes;
    end if;

    l_return := l_return || '>';

    l_return := l_return || q'[<span class="t-Button-label">]'|| p_item_label ||  q'[</span> </button>]';
    return l_return;
  end apex_item_button; 

  procedure get_preview(pi_pdf_id_column in varchar2,
                        pi_filename_column in varchar2,
                        pi_bolb_column in varchar2,
                        pi_tablename in varchar2,
                        pi_pdf_id in number,
                        pi_sql_statement in varchar2 default null
                      )
  as
    l_file blob;
    l_filename varchar2(4000);
    l_sql varchar2(4000);
  begin

    l_sql := 'select ' || dbms_assert.simple_sql_name(pi_filename_column) ||
             '     , ' || dbms_assert.simple_sql_name(pi_bolb_column) ||
             '  from ' || dbms_assert.sql_object_name(pi_tablename) ||
             ' where ' || dbms_assert.simple_sql_name(pi_pdf_id_column) || ' = :pdf_id'
    ;
   EXECUTE IMMEDIATE l_sql
                 INTO l_filename,
                      l_file
                USING pi_pdf_id;  


  sys.htp.init;
  sys.owa_util.mime_header( 'application/pdf', false );
  sys.htp.p('Content-length: ' || sys.dbms_lob.getlength( l_file));
  sys.htp.p('Content-Disposition: inline; filename="' || l_filename ||
  '"' );
  sys.owa_util.http_header_close;
  sys.wpg_docload.download_file( l_file );

  apex_application.stop_apex_engine;
  exception
  when others then
  raise;
  end get_preview;

  end thdevelop_util_pkg ;
  /