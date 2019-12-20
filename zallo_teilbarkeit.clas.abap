*&---------------------------------------------------------------------*
*& Report zallo_teilbarkeit
*&---aufgabe 3------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zallo_teilbarkeit.
DATA nums TYPE STANDARD TABLE OF int4.



DO 100  TIMES.
  DATA(num) = sy-index.
  IF num MOD 2 = 0 AND num MOD 3 = 0.

    INSERT num INTO TABLE nums.

  ENDIF.

ENDDO.

cl_demo_output=>display( nums ).
