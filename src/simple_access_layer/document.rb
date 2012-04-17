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

require File.expand_path( '../../document_file',     __FILE__ )
require File.expand_path( '../../elements/document', __FILE__ )
require File.expand_path( '../style',                __FILE__ )
require File.expand_path( '../table',                __FILE__ )

module SpreadBase

  module SimpleAccessLayer

    # This class wraps the file layer and the root document in a single concept.
    #
    class Document

      DEFAULT_TABLE_NAME = 'Sheet1'

      # Can be changed live.
      #
      attr_accessor :document_path

      attr_accessor :tables

      def initialize( document_path=nil )
        @document_path = document_path

        if filename
          raw_document = SpreadBase::DocumentFile.open( document_path )

          @styles = raw_document.styles.map { | raw_style | Style.from_raw_style( raw_document, raw_style ) }
          @tables = raw_document.tables.map { | raw_table | Table.from_raw_table( raw_table ) }
        else
          @styles = []
          @tables = [ Table.new( DEFAULT_TABLE_NAME ) ]
        end
      end

      def save
        document_raw = DEFAULT_CODEC.new.encode( @document )

        IO.write( @document_path, document_raw )
      end

    end

  end

end
