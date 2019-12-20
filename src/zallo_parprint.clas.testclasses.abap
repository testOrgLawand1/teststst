*"* use this source file for your ABAP unit test classes
CLASS ltc_parprint_test
DEFINITION FOR TESTING
DURATION SHORT
RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS: assert_print FOR TESTING ,
      assert_print2 FOR TESTING ,
      assert_print3 FOR TESTING .


ENDCLASS.


CLASS ltc_parprint_test IMPLEMENTATION.

  METHOD assert_print.

    DATA printer TYPE REF TO zallo_parprint.
    printer = NEW #( ).
   DATA(nums) = printer->print( EXPORTING dividend = 2 limit = 10   ).

    cl_abap_unit_assert=>assert_equals( exp = 2 act = nums[ 1 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 4 act = nums[ 2 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 6 act = nums[ 3 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 8 act = nums[ 4 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 10 act = nums[ 5 ] ).



  ENDMETHOD.



  METHOD assert_print2.

    DATA printer TYPE REF TO zallo_parprint.
    printer = NEW #( ).
    DATA(nums) = printer->print( EXPORTING dividend = 3 limit = 10   ).

    cl_abap_unit_assert=>assert_equals( exp = 3 act = nums[ 1 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 6 act = nums[ 2 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 9 act = nums[ 3 ] ).



  ENDMETHOD.

  METHOD assert_print3.

    DATA printer TYPE REF TO zallo_parprint.
    printer = NEW #( ).
   DATA(nums) = printer->print( EXPORTING dividend = 5 limit = 25  ).

    cl_abap_unit_assert=>assert_equals( exp = 5 act = nums[ 1 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 10 act = nums[ 2 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 15 act = nums[ 3 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 20 act = nums[ 4 ] ).
    cl_abap_unit_assert=>assert_equals( exp = 25 act = nums[ 5 ] ).



  ENDMETHOD.



ENDCLASS.
