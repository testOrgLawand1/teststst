CLASS zallo_ltd_rate_responder DEFINITION
  PUBLIC

  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES zallo_if_rate_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zallo_ltd_rate_responder IMPLEMENTATION.
  METHOD zallo_if_rate_provider~get_rate.
  if i_source = 'EUR' AND i_target = 'USD'.
  r_rate = '1.5' .
  ELSEIF i_source = 'USD' AND i_target = 'EUR'.
  r_rate = '0.6' .
  ELSE.
   RAISE EXCEPTION TYPE ycx_bs_msg.
  ENDIF.



  ENDMETHOD.

ENDCLASS.
