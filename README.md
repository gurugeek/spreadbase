SpreadBase!!
============

... because Excel IS a database.

What is SpreadBase©?
--------------------

SpreadBase© is a set of APIs for programmatically accessing spreadsheets (currently, only OpenDocument 1.2).

Warning!!!
----------

This document is based on the frozen API of the first version (0.1), which is going to be released on Tue 2012/04/24.

Usage
-----

Create/open a document:

    document = SpreadBase::Document.new( "Today's menu.ods" )

Add a table:

    document.tables << SpreadBase::Table.new(
      'Transistors', [
        [ 'Roasted 6502',                                 38.911 ],
        [ '65000 with side dishes of Copper and Blitter', 512.0  ],
      ]
    )

Modify an existing table; can be done also directly on the array:

    table = document.tables.first

    table.insert_row( 0, [ 'Dish',                    'Price' ] )
    table.insert_row( 2, [ '8080, with an 8-bit bus', 8       ] )

    table.insert_column( 2, [ 'Availability', Date.today, Time.now + 42, 'Never!!' ] )

Add another (empty) table:

    table_2 = SpreadBase::Table.new( 'Loud and annoying customers' )

    document.tables << table_2

Append a column:

    table_2.append_column( [ 'Name' ] )

Append a row:

    table_2.append_row( [ 'Fabrizio F.' ] )

Read a cell:

    price_8080 = document.tables[ 0 ][ 1, 2 ]

When a cell value is read from an existing file, the data type is directly converted to the closest ruby one.

Write to a cell:

    document.tables[ 0 ][ 1, 2 ] = price_8080 + 0.080

Print a table:

    puts document.tables[ 0 ].to_s( :with_headers => true )

    +----------------------------------------------+--------+---------------------------+
    | Dish                                         | Price  | Availability              |
    +----------------------------------------------+--------+---------------------------+
    | Roasted 6502                                 | 38.911 | 2012-04-21                |
    | 8080, with an 8-bit bus                      | 8.08   | 2012-04-21 11:45:08 +0200 |
    | 65000 with side dishes of Copper and Blitter | 512.0  | Never!!                   |
    +----------------------------------------------+--------+---------------------------+

Print a document:

    puts document.to_s( :with_headers => true )

    Transistors:

      +----------------------------------------------+--------+---------------------------+
      | Dish                                         | Price  | Availability              |
      +----------------------------------------------+--------+---------------------------+
      | Roasted 6502                                 | 38.911 | 2012-04-21                |
      | 8080, with an 8-bit bus                      | 8.08   | 2012-04-21 11:45:08 +0200 |
      | 65000 with side dishes of Copper and Blitter | 512.0  | Never!!                   |
      +----------------------------------------------+--------+---------------------------+

    Loud and annoying customers:

      +-------------+
      | Name        |
      +-------------+
      | Fabrizio F. |
      +-------------+

Save the document:

    document.save

Notes
-----

- The gem has been tested on Ruby 1.8.7 and 1.9.3-p125.
- The archives are always encoded in UTF-8. In Ruby 1.8.7, input strings are assumed to be UTF-8; if not, it's possible to open a document as:

  `SpreadBase::Document.new( "Today's menu.ods", :force_18_strings_encoding => '<encoding>' )`

  in order to override the input encoding.
- The column widths are retained (decoding/encoding), but at the current version, they're not [officially] accessible via any API.

Currently unsupported features
------------------------------

- Styles; Date and and [Date]Times are formatted as, respectively, '%Y-%m-%d' and '%Y-%m-%d %H:%M:%S %z'
- Percentage data type - they're handled using their float value (e.g. 50% = 0.5)

Roadmap/Todo
------------

https://github.com/saveriomiroddi/spreadbase/wiki/Todo-%28roadmap%29
