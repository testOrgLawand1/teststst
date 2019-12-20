CLASS zallo_ltc_wallet DEFINITION
  PUBLIC
  INHERITING FROM zallo_ltd_rate_responder
  CREATE PUBLIC.

  PUBLIC SECTION.


    DATA rate_provider TYPE REF TO zallo_if_rate_provider.
*
    DATA banknotes TYPE STANDARD TABLE OF REF TO zif_ps_banknote.


    METHODS: push IMPORTING i_banknote TYPE REF TO zif_ps_banknote ,
      pop  RETURNING VALUE(r_banknote) TYPE REF TO zif_ps_banknote EXCEPTIONS empty_wallet,
      length RETURNING VALUE(r_size) TYPE int4,
      get_aggregate_value IMPORTING i_currency      TYPE tpm_position_curr
                          RETURNING VALUE(r_amount) TYPE tpm_position_amt,

      convert_curr IMPORTING i_in_currency         TYPE tpm_position_curr
                   RETURNING VALUE(r_total_amount) TYPE tpm_position_amt.



  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zallo_ltc_wallet IMPLEMENTATION.

  METHOD push.

    READ TABLE banknotes WITH KEY table_line = i_banknote INTO DATA(banknote).
    DATA is_existing TYPE string.
    IF banknote <> i_banknote.
      INSERT i_banknote INTO TABLE banknotes.

    ENDIF.

*    is_existing = ''.
*    LOOP AT banknotes INTO data(banknote).

*    IF banknote = i_banknote.
*    is_existing = 'x'.
*    ELSE.
*
*    ENDIF.
*    ENDLOOP.
*
*    if is_existing = ''.
*    INSERT i_banknote INTO TABLE banknotes.
*    ELSE.
*    ENDIF.

  ENDMETHOD.

  METHOD pop.
    IF banknotes IS INITIAL.
      RAISE empty_wallet.
    ENDIF.

    DESCRIBE TABLE banknotes LINES DATA(count).
    r_banknote = banknotes[ count ].
    DELETE banknotes INDEX count.

  ENDMETHOD.

  METHOD length.
    DATA size TYPE int4.
    DESCRIBE TABLE banknotes LINES size.
    r_size = size.
  ENDMETHOD.

  METHOD get_aggregate_value.
    LOOP AT banknotes INTO DATA(banknote).
      IF banknote->get_currency( ) ='EUR'.
        IF i_currency = 'EUR'.
          DATA(value) = banknote->get_amount( ).
          r_amount += value.
        ENDIF.

      ELSEIF i_currency = 'USD'.
        IF i_currency = 'USD'.
          value = banknote->get_amount( ).
          r_amount += value.

        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.





  METHOD convert_curr.
  CREATE OBJECT rate_provider TYPE zallo_ltd_rate_responder.
    LOOP AT banknotes INTO DATA(banknote).
      IF banknote->get_currency( ) = i_in_currency.
        r_total_amount += banknote->get_amount( ).
      ELSE.
        r_total_amount +=  banknote->get_amount( ) * rate_provider->get_rate(
                                                          i_source = banknote->get_currency( )
                                                         i_target = i_in_currency
                                                        ) .

      ENDIF.

    ENDLOOP.
  ENDMETHOD.









ENDCLASS.


