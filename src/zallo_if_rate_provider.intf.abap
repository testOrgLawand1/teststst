INTERFACE zallo_if_rate_provider

  PUBLIC .

  CLASS-METHODS get_rate
    IMPORTING i_source      TYPE tpm_position_curr
              i_target      TYPE tpm_position_curr
    RETURNING VALUE(r_rate) TYPE tpm_position_value
    RAISING
      ycx_bs_msg.


ENDINTERFACE.
