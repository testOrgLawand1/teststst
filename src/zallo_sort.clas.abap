CLASS zallo_sort DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: sort IMPORTING num1 TYPE int4
                           num2 TYPE int4
                           num3 TYPE int4
                           RETURNING VALUE(r_SORTED) TYPE string .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zallo_sort IMPLEMENTATION.

  METHOD sort.

    DATA nums TYPE  TABLE OF int4   .
    INSERT num1 INTO TABLE nums.
    INSERT num2 INTO TABLE nums.
    INSERT num3 INTO TABLE nums.

    SORT nums ASCENDING.

    cl_demo_output=>display( nums ).



  ENDMETHOD.




ENDCLASS.
