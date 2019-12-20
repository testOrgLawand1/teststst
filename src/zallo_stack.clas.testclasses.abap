*"* use this source file for your ABAP unit test classes
CLASS ltc_base DEFINITION
FOR  TESTING
DURATION SHORT
RISK LEVEL HARMLESS.
  PROTECTED SECTION.
    DATA stack TYPE REF TO zallo_stack.
    METHODS: assert_length_is IMPORTING expected_size TYPE int4.
  PRIVATE SECTION.
    METHODS: setup.

ENDCLASS.

CLASS ltc_base IMPLEMENTATION.

  METHOD assert_length_is.


    cl_abap_unit_assert=>assert_equals(
   EXPORTING act = stack->length( )
             exp = expected_size

    ).

  ENDMETHOD.

  METHOD setup.
    stack = NEW #( ).
  ENDMETHOD.

ENDCLASS.


CLASS ltcl_fruitstack DEFINITION
INHERITING FROM ltc_base
FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.
  PUBLIC SECTION.
    METHODS push_fruit IMPORTING i_fruit TYPE string.



ENDCLASS.

CLASS ltcl_fruitstack IMPLEMENTATION.
  METHOD push_fruit.
    stack->push( i_fruit ).
  ENDMETHOD.


ENDCLASS.





CLASS ltcl_fruit_unit_test DEFINITION
INHERITING FROM ltcl_fruitstack
 FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS: add_and_pop_one_fruit FOR TESTING RAISING cx_static_check,
      add_and_pop_two_fruits FOR TESTING RAISING cx_static_check,
      add_one_fruit FOR TESTING RAISING cx_static_check.

ENDCLASS.





CLASS ltcl_fruit_unit_test IMPLEMENTATION.




  METHOD add_and_pop_one_fruit.

    push_fruit( 'apple').

    cl_abap_unit_assert=>assert_equals(
    EXPORTING act = stack->pop( )
              exp = 'apple'

     ).



    assert_length_is( 0 ).

  ENDMETHOD.





  METHOD add_and_pop_two_fruits.

    push_fruit( 'apple').
    push_fruit( 'banana').


    cl_abap_unit_assert=>assert_equals(
    EXPORTING act = stack->pop( )
              exp = 'banana'

     ).
    cl_abap_unit_assert=>assert_equals(
   EXPORTING act = stack->pop( )
             exp = 'apple'

    ).
    assert_length_is( 0 ).


  ENDMETHOD.

  METHOD add_one_fruit.

    push_fruit( 'apple').
    assert_length_is( 1 ).

  ENDMETHOD.


ENDCLASS.




CLASS ltcl_border_cases DEFINITION
INHERITING FROM ltc_base
FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS pop_empty FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_border_cases IMPLEMENTATION.

  METHOD pop_empty.

    stack->pop(

      EXCEPTIONS empty_stack = 1

      ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING act = sy-subrc
                exp = 1

       ).

    cl_abap_unit_assert=>assert_initial(

     act = 0

     ).

    assert_length_is( 0 ).


  ENDMETHOD.
ENDCLASS.
