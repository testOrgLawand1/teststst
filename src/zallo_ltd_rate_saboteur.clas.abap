CLASS zallo_ltd_rate_saboteur DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: zallo_if_rate_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zallo_ltd_rate_saboteur IMPLEMENTATION.


  METHOD zallo_if_rate_provider~get_rate.
  RAISE EXCEPTION TYPE ycx_bs_msg.
  ENDMETHOD.

ENDCLASS.
