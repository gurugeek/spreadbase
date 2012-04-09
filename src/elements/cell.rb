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

    # For simplification purposes, the concept of "text:p" has been flattened into this class.
    #
    class Cell

      attr_accessor :text
      attr_accessor :style
      attr_accessor :value_type
      attr_accessor :date_value
      attr_accessor :value
      attr_accessor :formula

      # attributes:
      #   :text
      #   :style
      #   :value_type
      #   :date_value
      #   :value
      #   :formula
      #
      def initialize( attributes={} )
        @text       = attributes[ :text       ]
        @style      = attributes[ :style      ]
        @value_type = attributes[ :value_type ]
        @date_value = attributes[ :date_value ]
        @value      = attributes[ :value      ]
        @formula    = attributes[ :formula    ]
      end

    end

  end

end
