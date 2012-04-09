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

    # "table:table" element
    #
    class Table

      attr_accessor :name
      attr_accessor :columns
      attr_accessor :rows

      # The name is not strictly necessary, but in the office suite, it is enforced, so it's set as
      # parameter, but not enforced.
      # It's necessary to have at least one column defined, otherwise the document is not rendered correctly.
      #
      # attributes:
      #   :columns      [[Column.new]
      #   :rows         [[]]
      #
      def initialize( name, attributes={} )
        @name    = name
        @columns = attributes[ :columns ] || [ Column.new ]
        @rows    = attributes[ :rows    ] || []
      end

    end

  end

end
