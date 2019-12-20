CLASS zallo_parprint DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES t_nums TYPE STANDARD TABLE OF int4 WITH NON-UNIQUE KEY TABLE_LINE.
    DATA nums TYPE t_nums.

    METHODS print
      IMPORTING limit        TYPE int4
                dividend     TYPE int4
      RETURNING VALUE(r_nums) TYPE t_nums.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zallo_parprint IMPLEMENTATION.
  METHOD print.
    DO limit  TIMES.
      DATA(num) = sy-index.
      IF num MOD Dividend = 0.

        INSERT num INTO TABLE nums.
        r_nums = nums.
      ENDIF.

    ENDDO.

  ENDMETHOD.
ENDCLASS.
