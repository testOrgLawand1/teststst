*&---------------------------------------------------------------------*
*& Report zallo_show_scheduled_jobs
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zallo_show_scheduled_jobs.


DATA joblist  TYPE STANDARD TABLE OF tbtcjob.
DATA jobs_scheduled  TYPE STANDARD TABLE OF tbtcjob.
CONSTANTS scheduled TYPE btcstatus VALUE 'S'.
TYPES: BEGIN OF t_scheduled_jobs,

         jobname   TYPE btcjob,
          progname TYPE btcrep,
         jobcount  TYPE btcjobcnt,
         variant   TYPE btcvariant,
         reluname  TYPE uname ,
         frequency TYPE zallo_frequency,
         client TYPE  btcauthman,
       END OF t_scheduled_jobs.
DATA scheduled_jobs TYPE TABLE OF t_scheduled_jobs.

"get all jobs of report ZSCI_RESULT_SEND_REPORT
CALL FUNCTION 'BP_FIND_JOBS_WITH_PROGRAM'
  EXPORTING
    abap_program_name             = 'ZALLO_EVA_EXERCIES'"'ZSCI_RESULT_SEND_REPORT'
*   abap_variant_name             = space
*   external_program_name         = space
*   dialog                        = space
*    status                        = scheduled
  TABLES
    joblist                       = joblist
  EXCEPTIONS
    no_jobs_found                 = 1
    program_specification_missing = 2
    invalid_dialog_type           = 3
    job_find_canceled             = 4
    OTHERS                        = 5.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

"filter scheduled jobs of report ZSCI_RESULT_SEND_REPORT
LOOP AT joblist INTO DATA(job).

  IF job-periodic IS NOT INITIAL AND job-authckman = sy-mandt.
    INSERT job INTO TABLE jobs_scheduled.
  ENDIF.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDLOOP.

CLEAR joblist.

"get all jobs of report RS_AUCV_RUNNER
CALL FUNCTION 'BP_FIND_JOBS_WITH_PROGRAM'
  EXPORTING
    abap_program_name             = 'RS_AUCV_RUNNER'
*   abap_variant_name             = space
*   external_program_name         = space
*   dialog                        = space
    status                        = scheduled
  TABLES
    joblist                       = joblist
  EXCEPTIONS
    no_jobs_found                 = 1
    program_specification_missing = 2
    invalid_dialog_type           = 3
    job_find_canceled             = 4
    OTHERS                        = 5.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

"filter scheduled jobs of report RS_AUCV_RUNNER
LOOP AT joblist INTO job.
   IF job-periodic IS NOT INITIAL AND job-authckman = sy-mandt.
    INSERT job INTO TABLE jobs_scheduled.
  ENDIF.
ENDLOOP.

"get all jobs of report SUT_AUNIT_RUNNER
CALL FUNCTION 'BP_FIND_JOBS_WITH_PROGRAM'
  EXPORTING
    abap_program_name             = 'SUT_AUNIT_RUNNER'
*   abap_variant_name             = space
*   external_program_name         = space
*   dialog                        = space
    status                        = scheduled
  TABLES
    joblist                       = joblist
  EXCEPTIONS
    no_jobs_found                 = 1
    program_specification_missing = 2
    invalid_dialog_type           = 3
    job_find_canceled             = 4
    OTHERS                        = 5.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

"filter scheduled jobs of report RS_AUCV_RUNNER
LOOP AT joblist INTO job.
  IF job-periodic IS NOT INITIAL AND job-authckman = sy-mandt.
    INSERT job INTO TABLE jobs_scheduled.
  ENDIF.
ENDLOOP.



"get variant and frequency for scheduled jobs
LOOP AT jobs_scheduled INTO DATA(job_scheduled).


  SELECT jobname, jobcount, variant, progname
  FROM   tbtcp
  INTO CORRESPONDING FIELDS OF TABLE @scheduled_jobs
  WHERE  jobname   = @job_scheduled-jobname
  AND    jobcount  = @job_scheduled-jobcount.
  READ TABLE scheduled_jobs INDEX 1 INTO data(scheduled_job_with_variant).
  scheduled_job_with_variant-reluname = job_scheduled-reluname.
  scheduled_job_with_variant-client = job_scheduled-authckman.
  DATA frequency TYPE char14.

  IF job_scheduled-prddays IS NOT INITIAL.
  DATA numb TYPE int4.
  numb = job_scheduled-prddays.
    frequency = |{ numb  } days|.
  ENDIF.

  IF job_scheduled-prdweeks IS NOT INITIAL.
  numb = job_scheduled-prdweeks.
    frequency = |{ numb  } weeks|.
  ENDIF.

  IF job_scheduled-prdmonths IS NOT INITIAL.
  numb = job_scheduled-prdmonths.
    frequency =  |{ numb  } months|.
  ENDIF.
  scheduled_job_with_variant-frequency = frequency.

  DATA scheduled_with_var_and_frequen LIKE scheduled_jobs.
  INSERT scheduled_job_with_variant INTO TABLE scheduled_with_var_and_frequen.

ENDLOOP.



TRY.
    cl_salv_table=>factory( IMPORTING r_salv_table = DATA(alv)
                            CHANGING t_table = scheduled_with_var_and_frequen  ).
  CATCH cx_salv_msg INTO DATA(error).
    DATA(message) = error->get_message( ).
    MESSAGE ID message-msgid TYPE message-msgty NUMBER message-msgno
      WITH message-msgv1 message-msgv2 message-msgv3 message-msgv4.
ENDTRY.

alv->get_functions( )->set_all( abap_true ).
alv->display( ).
