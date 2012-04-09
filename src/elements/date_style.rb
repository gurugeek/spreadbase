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

    # For simplification purposes, the child elements have been flattened into
    # this class.
    #
    class DateStyle

      attr_accessor :name, :patterns

      # patterns:        array of entries:
      #                    '<text>'                                          for text literals
      #                    [ '<element_name>'[,<attribute>[,<attribute>]] ]  for pattern attributes. <element_name> is expanded.
      #
      def initialize( name, *patterns )
        @name     = name
        @patterns = patterns
      end

    end

  end

end
