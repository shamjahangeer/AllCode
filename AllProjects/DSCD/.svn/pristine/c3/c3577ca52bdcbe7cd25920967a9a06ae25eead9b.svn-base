CREATE OR REPLACE PACKAGE SCD_Customer_Edit IS

    FUNCTION get_customer_key_id(io_customer_key_id   IN OUT NUMBER,
                                 i_customer_nbr       IN VARCHAR2,
                                 i_orgid              IN VARCHAR2,
                                 i_src_system         IN NUMBER,
                                 i_cust_number_type   IN VARCHAR2,
                                 i_point_in_time_flag IN VARCHAR2,
                                 i_dist_channel       IN VARCHAR2) RETURN BOOLEAN;


    --------------------------------------------------------------------------------------
    --   Purpose:  Insert a Skeleton Alpha customer record.
    --             Return the customer key id.
    --  IN Parms:  i_source_system_id - the source system id of the customer number
    --             i_sales_org_id - sap sales org
    --                  - if it is a legacy value, the API will figure out the correct value.
    --                  - if template SAP: send null; please note in the code comments that the API will derive this
    --                  - if not template SAP: send 0000
    --             i_orgid - The customer org id that you want to look up
    --             i_cust_nbr - this is the unformatted customer that you want to
    --                          look up.  You do not have to supply a suffix - the 
    --                          base alone will do.            
    --             i_dist_channel - distribution channel
    --                    - if template SAP: send the distribution_channel_cde that was sent on the ADR-43
    --                    - if not template SAP: send null.It will be defaulted to 01.  
    --             i_cust_number_type - This defines what kind of customer number is being
    --                                passed.  This currently uses two different parameters:
    --                    - c_sap_cust_number - the data comes straight from SAP, there is
    --                                          no concept of base/suffix
    --                    - c_base_sufx_number - the data comes from a traditional source like
    --                                           GBL_CURRENT or some other system where a
    --                                           base and/or a suffix exists
    --             i_point_in_time_flag - this overrides the as_of_date functionality as well as        
    --                          restricts key id searches to the appropriate point in time flag.        
    --                          So, if a customer is new as of this month, but the PME flag was       
    --                          used, you would get NOT_FOUND.  If you are using the point in time      
    --                          flag, this will always show the data as per the final key value.            
    --                    - c_gbl_current - the latest view of the data                                 
    --                    - c_gbl_PME - Prior Month End view of the data                                    
    --                    - c_gbl_PPME - Previous Prior Month End view of the data
    -- OUT Parms:  io_customer_key_id - the returned customer key id
    --    
    --------------------------------------------------------------------------------------

    FUNCTION add_skeleton_row(io_customer_key_id   IN OUT NUMBER,
                              i_source_system_id   IN NUMBER,
                              i_sales_org_id       IN VARCHAR2,
                              i_org_id             IN VARCHAR2,
                              i_cust_nbr           IN VARCHAR2,
                              i_dist_channel       IN VARCHAR2,
                              i_cust_number_type   IN VARCHAR2,
                              i_point_in_time_flag IN VARCHAR2) RETURN BOOLEAN;

END SCD_Customer_Edit;
/
CREATE OR REPLACE PACKAGE BODY SCD_Customer_Edit IS

    FUNCTION get_customer_key_id(io_customer_key_id   IN OUT NUMBER,
                                 i_customer_nbr       IN VARCHAR2,
                                 i_orgid              IN VARCHAR2,
                                 i_src_system         IN NUMBER,
                                 i_cust_number_type   IN VARCHAR2,
                                 i_point_in_time_flag IN VARCHAR2,
                                 i_dist_channel       IN VARCHAR2) RETURN BOOLEAN
    
     IS
        v_io_status  VARCHAR2(100);
        v_io_sqlcode NUMBER(10);
        v_io_sqlerrm VARCHAR2(200);
    
        v_called_routine VARCHAR2(100);
    
        subroutine_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT(subroutine_exception, -20101);
    
        New_Exception EXCEPTION;
    
    BEGIN
        v_called_routine := 'cor_customer.get_customer_key_id';
        cor_source.cor_customer.get_customer_key_id(v_io_status
                                                   ,v_io_sqlcode
                                                   ,v_io_sqlerrm
                                                   ,io_customer_key_id
                                                   ,i_orgid
                                                   ,i_customer_nbr
                                                   ,i_src_system
                                                   ,i_cust_number_type
                                                   ,i_point_in_time_flag
                                                   ,i_dist_channel);
    
        IF v_io_status = 'OK'
        THEN
            RETURN TRUE;
        ELSIF v_io_status = 'NOT_FOUND'
        THEN
            RETURN FALSE;
        ELSE
            --Daf_Trans_Vars.v_last_sql_code     := v_io_SQLCODE;
            --Daf_Trans_Vars.v_last_sql_msg_txt  := v_io_sqlerrm;
            --Daf_Trans_Vars.v_last_appl_msg_txt := 'Abort: Unexpected return from ' || v_called_routine;
            --Daf_Abort.put_log_rec('daf_customer_edit.get_customer_key_id');
            RAISE Subroutine_Exception;
        END IF;
    
    EXCEPTION
        WHEN Subroutine_Exception THEN
            RAISE_APPLICATION_ERROR(v_io_sqlcode
                                   ,v_io_sqlerrm || ' Abort: Unexpected return from ' || v_called_routine);
        
        WHEN New_Exception THEN
            --Daf_Abort.put_log_rec('daf_customer_edit.get_customer_key_id');
            RAISE_APPLICATION_ERROR(v_io_sqlcode, v_io_sqlerrm || ' Abort: SCD_Customer_Edit.get_customer_key_id');
        
        WHEN OTHERS THEN
            --Daf_Trans_Vars.v_last_sql_code     := SQLCODE;
            --Daf_Trans_Vars.v_last_sql_msg_txt  := SQLERRM;
            --Daf_Trans_Vars.v_last_appl_msg_txt := 'Aborted : Unexpected abort in logic - ' || v_called_routine;
            --Daf_Abort.put_log_rec('daf_customer_edit.get_customer_key_id');
            RAISE_APPLICATION_ERROR(v_io_sqlcode, v_io_sqlerrm || ' Abort: SCD_Customer_Edit.get_customer_key_id');
        
    END get_customer_key_id;

    FUNCTION add_skeleton_row(io_customer_key_id   IN OUT NUMBER,
                              i_source_system_id   IN NUMBER,
                              i_sales_org_id       IN VARCHAR2,
                              i_org_id             IN VARCHAR2,
                              i_cust_nbr           IN VARCHAR2,
                              i_dist_channel       IN VARCHAR2,
                              i_cust_number_type   IN VARCHAR2,
                              i_point_in_time_flag IN VARCHAR2) RETURN BOOLEAN
    
     IS
    
        v_io_status  VARCHAR2(100);
        v_io_sqlcode NUMBER(10);
        v_io_sqlerrm VARCHAR2(2000);
    
        subroutine_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT(subroutine_exception, -20101);
    
        New_Exception EXCEPTION;
    
    BEGIN
        -- Call cmd_customer_edit.add_skeleton_row
        cmd_source.cmd_customer_edit.add_skeleton_row(v_io_status
                                                     ,v_io_sqlcode
                                                     ,v_io_sqlerrm
                                                     ,io_customer_key_id
                                                     ,i_source_system_id
                                                     ,i_sales_org_id
                                                     ,i_org_id
                                                     ,i_cust_nbr
                                                     ,i_dist_channel
                                                     ,i_cust_number_type
                                                     ,i_point_in_time_flag);
    
        IF v_io_status = 'OK'
        THEN
            RETURN TRUE;
        ELSIF v_io_status = 'NOT_FOUND'
        THEN
            RETURN FALSE;
        ELSE
            RAISE Subroutine_Exception;
        END IF;
    
    EXCEPTION
        WHEN Subroutine_Exception THEN
            RAISE_APPLICATION_ERROR(v_io_sqlcode, v_io_sqlerrm);
        
        WHEN New_Exception THEN
            RAISE_APPLICATION_ERROR(-20101, 'appl abend');
        
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(v_io_sqlcode, v_io_sqlerrm);
        
    END add_skeleton_row;

END SCD_Customer_Edit;
/
