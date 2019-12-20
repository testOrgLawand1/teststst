*&---------------------------------------------------------------------*
*& Report zallo_teilbarpar
*&-----aufgabe 5----------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zallo_teilbarpar.
TABLES tadir.

PARAMETERS: limit TYPE int4,
            dividend TYPE int4.

SELECT-OPTIONS test FOR tadir-author.
  SELECT * FROM tadir
  WHERE author IN @test INTO TABLE @data(t_test).



DATA printer TYPE REF TO zallo_parprint.
printer = new #( ).
data(nums) = printer->print( dividend = dividend limit = limit ).
cl_demo_output=>display( nums ).

*SUBMIT zallo_sort VIA SELECTION-SCREEN.
