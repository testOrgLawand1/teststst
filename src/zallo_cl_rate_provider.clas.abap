CLASS zallo_cl_rate_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  METHODS: get_rate IMPORTING i_source TYPE tpm_position_curr
                              i_target TYPE tpm_position_curr
                    RETURNING VALUE(r_rate) TYPE tpm_position_value .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zallo_cl_rate_provider IMPLEMENTATION.
  METHOD get_rate.





  ENDMETHOD.

ENDCLASS.
