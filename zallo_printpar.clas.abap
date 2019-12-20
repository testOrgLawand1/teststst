*&---------------------------------------------------------------------*
*& Report zallo_printpar
*&-----aufgabe 4----------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zallo_printpar.
PARAMETERS limit TYPE int4.
DATA nums TYPE STANDARD TABLE OF int4.
DO limit TIMES.
data(num) = sy-index.
INSERT num INTO TABLE nums.

ENDDO.

cl_demo_output=>display( nums ).
