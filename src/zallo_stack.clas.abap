CLASS zallo_stack DEFINITION
  PUBLIC

  CREATE PUBLIC.

  PUBLIC SECTION.

    DATA gt_basket TYPE STANDARD TABLE OF string.
    METHODS:
      push
        IMPORTING i_fruit TYPE string,
      pop
        RETURNING VALUE(r_fruit) TYPE string

        EXCEPTIONS empty_stack,
      length
      RETURNING VALUE(r_size) TYPE int4.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zallo_stack IMPLEMENTATION.

  METHOD push.
    INSERT i_fruit INTO TABLE gt_basket.
  ENDMETHOD.

  METHOD pop.
    DATA count TYPE int4.

    IF gt_basket IS INITIAL.
      RAISE empty_stack.
    ENDIF.

    DESCRIBE TABLE gt_basket LINES count.
    r_fruit = gt_basket[ count ].
    DELETE gt_basket INDEX count.

  ENDMETHOD.

  METHOD length.
    DATA size TYPE int4.
    DESCRIBE TABLE gt_basket LINES size.
    r_size = size.

  ENDMETHOD.

ENDCLASS.
