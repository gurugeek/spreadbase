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

module SpreadBase

  module Elements

    # For simplification purposes, this represents a merge of the abstractions of thee document
    # and the spreadsheet.
    #
    class Document

      attr_accessor :styles
      attr_accessor :tables

      # attributes:
      #   :styles         [[]]
      #   :tables         [[]]
      #
      def initialize( attributes={} )
        @styles = attributes[ :styles ] || []
        @tables = attributes[ :tables ] || []
      end

    end

  end

end
