
*&---------------------------------------------------------------------*
*& Report zallo_eva_exercies
* aufgabe2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zallo_eva_exercies.
DATA nums TYPE STANDARD TABLE OF int4.

DO 10 TIMES.
  DATA(num) = sy-index.
  INSERT num INTO TABLE nums.

ENDDO.

cl_demo_output=>display( nums ).
