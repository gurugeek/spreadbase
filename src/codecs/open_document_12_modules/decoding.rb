=begin
Copyright 2012 Saverio Miroddi saverio.pub2 <a-hat!> gmail.com

This file is part of SpreadBase.

SpreadBase is free software: you can redistribute it and/or modify it under the
terms of the GNU Lesser General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

SpreadBase is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with SpreadBase.  If not, see <http://www.gnu.org/licenses/>.
=end

require File.expand_path( '../../../elements/date_style', __FILE__ )

module SpreadBase

  module Codecs

    module OpenDocument12Modules

      module Decoding

        # Returns a Document instance.
        #
        def decode_document( root_node )
          document = Elements::Document.new

          style_nodes = root_node.elements.to_a( '//office:document-content/office:automatic-styles/*' )
          table_nodes = root_node.elements.to_a( '//office:document-content/office:body/office:spreadsheet/table:table' )

          # :compact => skip unrecognized styles, which are not decoded
          #
          document.styles = style_nodes.map { | node | decode_generic_style_node( node ) }.compact
          document.tables = table_nodes.map { | node | decode_table_node( node ) }

          document
        end

        def decode_generic_style_node( style_node )
          case style_node.expanded_name
          when 'style:style'
            decode_style_node( style_node )
          when 'number:date-style'
            decode_date_style_node( style_node )
          end
        end

        def decode_date_style_node( date_style_node )
          date_style = Elements::DateStyle.new( date_style_node.attributes[ 'style:name' ] )

          date_style_node.elements.each do | pattern_node |
            date_style.patterns << decode_date_style_pattern_node( pattern_node )
          end

          # :compact => skip unrecognized patterns, which are not decoded
          #
          date_style.patterns

          date_style
        end

        def decode_date_style_pattern_node( pattern_node )
          name = pattern_node.expanded_name

          case name
          when OpenDocument12Modules::DateStyleConstants::YEAR,
               OpenDocument12Modules::DateStyleConstants::MONTH,
               OpenDocument12Modules::DateStyleConstants::DAY,
               OpenDocument12Modules::DateStyleConstants::HOURS,
               OpenDocument12Modules::DateStyleConstants::MINUTES,
               OpenDocument12Modules::DateStyleConstants::SECOND,
               OpenDocument12Modules::DateStyleConstants::AM_PM,
               OpenDocument12Modules::DateStyleConstants::DAY_OF_WEEK,
               OpenDocument12Modules::DateStyleConstants::WEEK_OF_YEAR,
               OpenDocument12Modules::DateStyleConstants::QUARTER
            pattern = [ name ]

            pattern << OpenDocument12Modules::DateStyleConstants::LONG    if pattern_node.attributes[ 'number:style'   ] == 'long'
            pattern << OpenDocument12Modules::DateStyleConstants::TEXTUAL if pattern_node.attributes[ 'number:textual' ] == 'true'

            pattern
          when OpenDocument12Modules::DateStyleConstants::TEXT
            pattern_node.text || ''
          end
        end

        def decode_style_node( style_node )
          style = Elements::Style.new( style_node.attributes[ 'style:name' ] )

          style.data_style_name = style_node.attributes[ 'style:data-style-name' ]

          text_properties_node = style_node.elements[ 'style:text-properties' ]

          if text_properties_node
            style.font_weight          = text_properties_node.attributes[ 'fo:font-weight'             ]
            style.font_style           = text_properties_node.attributes[ 'fo:font-style'              ]
            style.text_underline_style = text_properties_node.attributes[ 'style:text-underline-style' ]
          end

          style
        end

        def decode_table_node( table_node )
          table = Elements::Table.new( table_node.attributes[ 'table:name' ] )

          column_nodes = table_node.elements.to_a( 'table:table-column' )
          row_nodes    = table_node.elements.to_a( 'table:table-row'    )
          
          table.columns = column_nodes.map { | node | decode_column_node( node ) } 
          table.rows    = row_nodes.map { | node | decode_row_node( node ) }

          table
        end

        def decode_column_node( column_node )
          column = Elements::Column.new

          column.default_cell_style = column_node.attributes[ 'table:default-cell-style-name' ]

          column
        end

        def decode_row_node( row_node )
          row = Elements::Row.new

          row.style = row_node.attributes[ 'table:style-name'  ]

          cell_nodes = row_node.elements.to_a( 'table:table-cell' )

          row.cells = cell_nodes.map { | node | decode_cell_node( node ) }

          row
        end

        def decode_cell_node( cell_node )
          cell = SpreadBase::Elements::Cell.new

          value_node = cell_node.elements[ 'text:p' ]

          if value_node
            cell.text       = value_node.text
            cell.style      = cell_node.attributes[ 'table:style-name'  ]
            cell.value_type = cell_node.attributes[ 'office:value-type' ]
            cell.date_value = cell_node.attributes[ 'office:date-value' ]
            cell.value      = cell_node.attributes[ 'office:value'      ]
            cell.formula    = cell_node.attributes[ 'table:formula'     ]
          end

          cell
        end

      end

    end

  end

end
