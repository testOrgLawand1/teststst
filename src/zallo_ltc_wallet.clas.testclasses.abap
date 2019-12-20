*"* use this source file for your ABAP unit test classes
CLASS lth_cash_generator DEFINITION FOR TESTING

RISK LEVEL HARMLESS DURATION SHORT.


  PROTECTED SECTION.
    DATA: wallet TYPE REF TO zallo_ltc_wallet.

    METHODS:  create_banknote       IMPORTING i_amount          TYPE tpm_position_amt
                                              i_currency        TYPE tpm_position_curr DEFAULT 'EUR'
                                    RETURNING VALUE(r_banknote) TYPE REF TO zif_ps_banknote,

              assert_wallet_amount  IMPORTING i_amount   TYPE tpm_position_amt
                                     I_currency TYPE tpm_position_curr,
              assert_wallet_length  IMPORTING i_length TYPE  int4,
              assert_equals         IMPORTING exp TYPE any
                                            act TYPE any.


  PRIVATE SECTION.
    METHODS setup.
ENDCLASS.

CLASS lth_cash_generator IMPLEMENTATION.

  METHOD setup.
    wallet = NEW #( ).
  ENDMETHOD.

  METHOD create_banknote.
    r_banknote = zcl_ps_create_banknote=>create( i_amount = i_amount  i_currency = i_currency ).
  ENDMETHOD.

  METHOD assert_equals.

    cl_abap_unit_assert=>assert_equals( exp = exp  act = act ).
  ENDMETHOD.

  METHOD assert_wallet_length.
    assert_equals( exp = i_length  act = wallet->length( ) ).
  ENDMETHOD.

  METHOD assert_wallet_amount.
    assert_equals( exp = i_amount  act = wallet->get_aggregate_value( i_currency ) ).
  ENDMETHOD.






ENDCLASS.


CLASS ltc_single_currency DEFINITION FOR TESTING
INHERITING FROM lth_cash_generator
RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS: add_one_banknote FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltc_single_currency IMPLEMENTATION.

  METHOD add_one_banknote.

    wallet->push( create_banknote( i_amount = 50 i_currency = 'EUR' ) ).
    assert_wallet_length( 1 ).
    assert_wallet_amount(  i_amount = 50  i_currency = 'EUR' ).


  ENDMETHOD.



ENDCLASS.


CLASS ltc_multi_currency DEFINITION FOR TESTING
INHERITING FROM lth_cash_generator
RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS: add_notes_with_diff_currs FOR TESTING RAISING cx_static_check,
      add_same_banknote FOR TESTING RAISING cx_static_check,
      add_and_remove_banknotes FOR TESTING RAISING cx_static_check,
      get_total_amount FOR TESTING RAISING cx_static_check,
      total_amount_missing_rate FOR TESTING RAISING cx_static_check,
      test FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltc_multi_currency IMPLEMENTATION.

  METHOD add_notes_with_diff_currs.

    DATA(usd_50) = create_banknote( i_amount = 50  i_currency = 'USD').
    DATA(usd_60) = create_banknote( i_amount = 60  i_currency = 'USD' ).
    DATA(usd_80) = create_banknote( i_amount = 80  i_currency = 'EUR' ).
    wallet->push( usd_50 ).
    wallet->push( usd_60 ).
    wallet->push( usd_80 ).
    assert_wallet_length( 3 ).
    assert_wallet_amount(  i_amount = 80  i_currency = 'EUR' ).
    assert_wallet_amount(  i_amount = 110  i_currency = 'USD' ).
  ENDMETHOD.

  METHOD add_same_banknote.
    DATA(usd_50) = create_banknote( i_amount = 50  i_currency = 'USD').
    wallet->push( usd_50 ).
    wallet->push( usd_50 ).
    assert_wallet_length( 1 ).


  ENDMETHOD.

  METHOD add_and_remove_banknotes.

    DATA(usd_50) = create_banknote( i_amount = 50  i_currency = 'USD').
    DATA(usd_60) = create_banknote( i_amount = 60  i_currency = 'USD' ).
    DATA(usd_80) = create_banknote( i_amount = 80  i_currency = 'EUR' ).
    wallet->push( usd_50 ).
    wallet->push( usd_60 ).
    wallet->push( usd_80 ).
    wallet->pop( ).
    assert_wallet_length( 2 ).
    assert_wallet_amount(  i_amount = 0  i_currency = 'EUR' ).
    assert_wallet_amount(  i_amount = 110  i_currency = 'USD' ).

  ENDMETHOD.

  METHOD get_total_amount.

    DATA(usd_50) = create_banknote( i_amount = 50  i_currency = 'USD').
    DATA(usd_80) = create_banknote( i_amount = 80  i_currency = 'EUR' ).
    wallet->push( usd_50 ).
    wallet->push( usd_80 ).
    assert_wallet_length( 2 ).
*    assert_equals( exp = 110 act = wallet->convert_curr( i_in_currency = 'EUR' )  ).
    assert_equals( exp = 170  act = wallet->convert_curr( i_in_currency = 'USD' )  ).





  ENDMETHOD.



  METHOD total_amount_missing_rate.

    DATA: saboteur TYPE REF TO zallo_if_rate_provider.

    CREATE OBJECT    saboteur  TYPE zallo_ltd_rate_saboteur.
    create_banknote( i_amount = 10 i_currency = 'USD' ) .

    TRY.
        wallet->convert_curr( 'YEN' ).
      CATCH ycx_bs_msg.
    ENDTRY.

  ENDMETHOD.
  METHOD test.

  data(test) = abap_true.
  cl_abap_unit_assert=>assert_false( test ).
  ENDMETHOD.


ENDCLASS.
