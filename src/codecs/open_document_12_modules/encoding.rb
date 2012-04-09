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

require File.expand_path( '../../../elements/style',      __FILE__ )
require File.expand_path( '../../../elements/date_style', __FILE__ )
require File.expand_path( '../style_constants',           __FILE__ )
require File.expand_path( '../date_style_constants',      __FILE__ )

module SpreadBase

  module Codecs

    module OpenDocument12Modules

      module Encoding
  
        # Actually a document can be opened even without the office:body element, but we simplify the code
        # by assuming that at least this tree is present.
        #
        BASE_CONTENT_XML = %Q[\
<?xml version='1.0' encoding='UTF-8'?> 
<office:document-content
    xmlns:office='urn:oasis:names:tc:opendocument:xmlns:office:1.0'
    xmlns:style='urn:oasis:names:tc:opendocument:xmlns:style:1.0'
    xmlns:table='urn:oasis:names:tc:opendocument:xmlns:table:1.0'
    xmlns:text='urn:oasis:names:tc:opendocument:xmlns:text:1.0'
    xmlns:fo='urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0'
    xmlns:number='urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0'
    xmlns:of='urn:oasis:names:tc:opendocument:xmlns:of:1.2'
    office:version='1.2'>
<office:automatic-styles/>
<office:body>
  <office:spreadsheet/>
</office:body>
</office:document-content>]

        # Returns the XML root node
        #
        def encode_document( document )
          root_node        = REXML::Document.new( BASE_CONTENT_XML )
          styles_node      = root_node.elements[ '//office:document-content/office:automatic-styles' ]
          spreadsheet_node = root_node.elements[ '//office:document-content/office:body/office:spreadsheet' ]

          document.styles.each do | style |
            encode_generic_style( style, styles_node )
          end

          document.tables.each do | table |
            encode_table( table, spreadsheet_node )
          end

          root_node
        end

        def encode_generic_style( style, styles_node )
          case style
          when Elements::DateStyle
            encode_date_style( style, styles_node )
          when Elements::Style
            encode_style( style, styles_node )
          else
            raise "Unrecognized style class: #{ style.class }"
          end
        end

        def encode_date_style( style, styles_node )
          style_node = styles_node.add_element( 'number:date-style', 'style:name' => style.name )

          style.patterns.each do | pattern |
            case pattern
            when Array
              pattern_name, *pattern_attributes = pattern

              pattern_element = style_node.add_element( pattern_name )

              pattern_element.attributes[ 'number:style'   ] = 'long' if pattern_attributes.include?( OpenDocument12Modules::DateStyleConstants::LONG    )
              pattern_element.attributes[ 'number:textual' ] = 'true' if pattern_attributes.include?( OpenDocument12Modules::DateStyleConstants::TEXTUAL )
            when String
              text_element = style_node.add_element( 'number:text' )

              text_element.text = pattern
            else
              raise "Unrecognized pattern class: #{ pattern.class }"
            end
          end
        end

        def encode_style( style, styles_node )
          style_node = styles_node.add_element( 'style:style', 'style:name' => style.name, 'style:family' => style.style_family )

          style_node.attributes[ 'style:data-style-name' ] = style.data_style_name if style.data_style_name

          if style.font_weight || style.font_style || style.text_underline_style
            text_properties_node = style_node.add_element( 'style:text-properties' )

            text_properties_node.attributes[ 'fo:font-weight'             ] = style.font_weight          if style.font_weight
            text_properties_node.attributes[ 'fo:font-style'              ] = style.font_style           if style.font_style
            text_properties_node.attributes[ 'style:text-underline-style' ] = style.text_underline_style if style.text_underline_style
          end
        end

        def encode_table( table, spreadsheet_node )
          table_node = spreadsheet_node.add_element( 'table:table' )

          table_node.attributes[ 'table:name' ] = table.name if table.name

          table.columns.each do | column |
            column_node = table_node.add_element( 'table:table-column' )

            column_node.attributes[ 'table:default-cell-style-name' ] = column.default_cell_style if column.default_cell_style
          end

          table.rows.each do | row |
            encode_row( row, table_node )
          end
        end

        def encode_row( row, table_node )
          row_node = table_node.add_element( 'table:table-row' )

          row_node.attributes[ 'table:style-name' ] = row.style if row.style

          row.cells.each do | cell |
            encode_cell( cell, row_node )
          end
        end

        def encode_cell( cell, row_node )
          cell_node = row_node.add_element( 'table:table-cell' )

          cell_node.attributes[ 'table:style-name'  ] = cell.style      if cell.style
          cell_node.attributes[ 'office:value-type' ] = cell.value_type if cell.value_type
          cell_node.attributes[ 'office:date-value' ] = cell.date_value if cell.date_value
          cell_node.attributes[ 'office:value'      ] = cell.value      if cell.value
          cell_node.attributes[ 'table:formula'     ] = cell.formula    if cell.formula

          if cell.text
            cell_value_node = cell_node.add_element( 'text:p' )
            cell_value_node.text = cell.text
          end
        end
      end

    end

  end

end
