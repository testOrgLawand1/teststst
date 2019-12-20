*&---------------------------------------------------------------------*
*& Report zallo_sort
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zallo_sort.

PARAMETERS pa_num1 TYPE int4.
PARAMETERS pa_num2 TYPE int4.
PARAMETERS pa_num3 TYPE int4.

*

DATA sorter TYPE REF TO zallo_sort.
sorter = new #( ).

sorter->sort( num1 = pa_num1 num2 = pa_num2 num3 = pa_num3 ).
