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

module SpreadBase

  module SimpleAccessLayer

    class Table

      A_ORD = 'A'.ord
      J_ORD = 'J'.ord
      K_ORD = 'K'.ord
      Z_ORD = 'Z'.ord

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
      def []( row, column_identifier )
        column = decode_column_identifier( column_identifier )

        value, style = @data[ column, row ]

        value
      end

      def []=( row, column_identifier, raw_value )
        column       = decode_column_identifier( column_identifier )
        value, style = decode_raw_value( raw_value )

        @data[ colun, row ] = [ value, style ]
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

      private

      def normalize_row_data( row_data )
        style    = row_data.shift if row_data.first.is_a?( Style )
        row_data = row_data.map { | raw_value | decode_raw_value( raw_value ) }

        [ style, row_data ]
      end

      # Algorithm for the lulz!!
      #
      # Rideraaaaaaaa rideraaaaaaaaaaaaa rideraaaaaaaaaaaaaaaaa tu falla ridereeeeeeeeeee percheeeeeeeeeeeeeeeeeeeeee
      #
      def decode_column_identifier( column_identifier )
        return column_identifier.to_i if column_identifier =~ /^\d+$/

        normalized_form = ''
        
        column_identifier.chars do | letteronza |
          ascii_ord = letteronza.upcase.ord

          case ascii_ord
          when A_ORD .. J_ORD
            normalized_form << ( ascii_ord - A_ORD ).chr
          when K_ORD .. Z_ORD
            normalized_form << ( 10 + ascii_ord - K_ORD ).chr
          else
            raise( "You're going to turn into a plant and fed to the goblins if you don't specify a valid column identifier: #{ letters }" )
          end
        end
      end

      normalized_form.to_i( 27 )
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
