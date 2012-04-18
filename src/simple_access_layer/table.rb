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

require File.expand_path( '../../elements/date_style', __FILE__ )
require File.expand_path( '../../elements/style',      __FILE__ )

require 'date'
require 'time'

module SpreadBase

  module SimpleAccessLayer

    class Table

      attr_accessor :name

      # :name              mandatory non-blank
      # :column_styles     optional
      # :row_data          see wiki for specification
      #
      def initialize( name, column_styles, *rows_data )
        raise "Name must be a non-empty string" if ( name || '' ) == ''

        @name          = name
        @column_styles = column_styles
        @data          = rows_data.map { | row_data | normalize_row_data( row_data ) }
      end

      def self.from_raw_table( raw_style )
        raise "wm!"
      end

      # Indexes are zero-based (column can be optionally letter-based)
      #
      # Maledetta primavera!!
      #
      def []( column_identifier, row_index )
        column_index = decode_column_identifier( column_identifier )

        value, style = @data[ row_index ][ column_index + 1 ]

        value
      end

      def []=( column_identifier, row_index, raw_value )
        column_index = decode_column_identifier( column_identifier )
        value, style = decode_raw_value( raw_value )

        @data[ row_index ][ column_index + 1 ] = [ value, style ]
      end

      # row_index         zero-based
      #
      def row( row_index )
        @data[ row_index ][ 1 .. -1 ].map { | raw_value | raw_value.first }
      end

      # row_index         zero-based
      #
      def delete_row( row_index )
        @data.slice!( row_index )
      end

      # row_data          row_data format
      # index             [rows number] can be higher than rows number - in this case, the space will be filled
      #                   with unstyled empty rows.
      #
      def insert_row( row_data, index=@data.size )
        row_style, row_values = normalize_row_data( row_data )

        # Extend number of columns column_values with null styles, if required
        #
        @column_styles[ @row_values.size - 1 ] = nil if @column_styles.size < @row_values.size

        ( @data.size ... index ).each do | filling_index |
          @data[ filling_index ] = [ nil ]
        end

        @data.insert( index, [ row_style, row_values ] )
      end

      # column_index      zero-based. returns nil if the index is greater than the
      #                   number of columns.
      #
      def column( column_index )
        raw_values = @data.map { | row_data | row_data[ column_index + 1 ] || [] }

        raw_values.map { | raw_value | raw_value.first }
      end

      def delete_column( column_index )
        @column_styles.slice!( column_index )

        @data.each do | row_data |
          row_data.slice!( column_index + 1 )
        end
      end

      # column_data       use row_data format. if the number 
      # index             [rows number] can be higher than columns number - in this case, the space will be filled
      #                   with unstyled empty columns.
      #
      def insert_column( column_data, index=@columns.size )
        raise "if the values are more than the rows!!!!"

        column_style, column_values = normalize_row_data( column_data )

        @column_styles.insert( index, column_style )

        # Extend column_values with null values, if required
        #
        column_values[ @data.size - 1 ] = nil if column_values.size < @data.size

        # At this point, column_values can only be as long or longer than @data
        #
        column_values.zip( @data ).each do | value, row_data |
          if row_data.nil?
            # @columns_styles.size +1 (style) and -1 (it's a pre-insertion row)
            #
            row_data = [ nil ] * @column_styles.size

            @data << row_data
          end

          row_data.insert( index + 1, value )
        end
      end

      def data
        ( 0 ... @data.size ).map do | row_index |
          row( row_index )
        end
      end

      def column_style( column_identifier )
        column_index = decode_column_identifier( column_identifier )

        @column_styles[ column_index ]
      end

      def row_style( row_index )
        @data[ row_index ][ 0 ]
      end

      # WATCH OUT! There is no inheritance mechanism.
      #
      def cell_style( column_identifier, row_index )
        column_index = decode_column_identifier( column_identifier )

        @data[ row_index ][ column_index + 1 ][ 1 ]
      end

      def set_column_style( style, column_index )
        raise "Off-limit index for column style: #{ column_index }" if column_index >= @column_styles.size

        @column_styles[ column_index ] = style
      end

      def set_row_style( style, row_index )
        raise "Off-limit index for row style: #{ row_index }" if row_index >= @data.size

        @data[ row_index ][ 0 ] = style
      end

      def set_cell_style( style, column_index, row_index )
        raise "Off-limit row index for cell style: #{ row_index }"       if row_index >= @data.size
        raise "Off-limit column index for cell style: #{ column_index }" if column_index >= @column_styles.size

        row_style, row_data = @data[ row_index ]

        row_style[ column_index + 1 ][ 1 ] = style
      end

      def to_s
        @data.inject( "" ) do | buffer, ( style, *row_values ) |

          buffer << row_values.map { | raw_value | raw_value.first }.map { | value | value.inspect }.join( ', ' ) << "\n"
        end
      end

      private

      def normalize_row_data( row_data )
        style    = row_data.shift if row_data.first.is_a?( Style )
        row_data = row_data.map { | raw_value | decode_raw_value( raw_value ) }

        [ style, *row_data ]
      end


      # Accepts either an integer, or a MoFoBase26BisexNumber.
      # Returns a 0-based decimal number.
      #
      # Motherf#### base-26 bijective numeration - I would have gladly saved my f* time. At least
      # there were a few cute ladies at the Charleston lesson.
      #
      def decode_column_identifier( column_identifier )
        return column_identifier if column_identifier.is_a?( Fixnum )

        letters = column_identifier.upcase.chars.to_a

        raise "Invalid letter for in column identifier (allowed 'a/A' to 'z/Z')" if letters.any? { | letter | letter < 'A' || letter > 'Z' }
        raise "Invalid literal column identifier (allowed 'A' to 'AMJ')" if letters.size == 0 || letters.size > 3

        base_10_value = letters.inject( 0 ) { | sum, letter | sum * 26 + ( letter.ord - 'A'.ord + 1 ) } - 1

        raise "The maximum allowed column identifier is 'AMJ'" if base_10_value > 1023

        base_10_value
      end

      def decode_raw_value( raw_value )
        if raw_value.is_a?( Array )
          raise "Howard the duck is coming to rescue your invalid value: #{ raw_value } - only <value>/[<value>, <style>] are allowed." unless raw_value.size == 2 && raw_value[ 1 ].is_a?( Style )

          value, style = raw_value
        else
          value = raw_value
        end

        case value
        when Date, Time, DateTime, Float, Fixnum, String, nil
          # attaboy!!
        else
          raise "Unexpected data type: #{ value.class }. Macarena is a tramp."
        end

        [ value, style ]
      end

    end

  end

end
