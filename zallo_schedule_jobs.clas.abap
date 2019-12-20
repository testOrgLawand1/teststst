*&---------------------------------------------------------------------*
*& Report zallo_schedule_jobs
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zallo_schedule_jobs.

PARAMETERS p_jbname TYPE btcjob.
PARAMETERS p_rprtnm  TYPE btcrep .
PARAMETERS p_strtdt TYPE btcsdate.
PARAMETERS p_strttm  type btcstime.


CONSTANTS btc_no TYPE btcchar1  VALUE 'N'.
DATA job_to_be_scheduled TYPE tbtcjob.
DATA job_count TYPE btcjobcnt .
DATA step_list TYPE STANDARD TABLE OF tbtcstep.
DATA step TYPE tbtcstep.
* Step details
step-typ = 'E'.
step-authcknam = sy-mandt.
step-program = p_rprtnm.
step-language = 'EN'.
APPEND step TO step_list.
"todo: fill in job_to_be_scheduled and variant and step_list

job_to_be_scheduled-jobname = p_jbname.
job_to_be_scheduled-periodic = abap_true.
job_to_be_scheduled-prdweeks = 1.
job_to_be_scheduled-eventid = p_jbname.
job_to_be_scheduled-authckman = sy-mandt.
job_to_be_scheduled-periodic = abap_true.
job_to_be_scheduled-prdweeks = 01.

CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = p_jbname
    IMPORTING
      jobcount         = job_count
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE e888(sabapdocu) WITH 'JOB_OPEN FAILED'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'JOB_SUBMIT'
    EXPORTING
      authcknam               = sy-uname
      jobcount                = job_count
      jobname                 = p_jbname
      report                  = p_rprtnm
      variant                 = ''
    EXCEPTIONS
      bad_priparams           = 1
      bad_xpgflags            = 2
      invalid_jobdata         = 3
      jobname_missing         = 4
      job_notex               = 5
      job_submit_failed       = 6
      lock_failed             = 7
      program_missing         = 8
      prog_abap_and_extpg_set = 9
      OTHERS                  = 10.
  IF sy-subrc <> 0.
    MESSAGE e888(sabapdocu) WITH 'JOB_SUBMIT FAILED'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = job_count
      jobname              = p_jbname
      strtimmed            = abap_false
      prdweeks             = '1'
      sdlstrtdt            = p_strtdt
      sdlstrttm            = p_strttm

    EXCEPTIONS
      cant_start_immediate = 1
      invalid_startdate    = 2
      jobname_missing      = 3
      job_close_failed     = 4
      job_nosteps          = 5
      job_notex            = 6
      lock_failed          = 7
      invalid_target       = 8
      OTHERS               = 9.
  IF sy-subrc <> 0.
    MESSAGE e888(sabapdocu) WITH 'JOB_CLOSE FAILED'.
    EXIT.
  ENDIF.
  COMMIT WORK AND WAIT.

  SUBMIT zallo_show_scheduled_jobs.
