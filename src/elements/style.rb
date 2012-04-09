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

    # Currently only supports table-cell styles
    #
    # For simplification purposes, the concept of "style:text-properties" has been flattened into
    # this class.
    #
    class Style

      attr_accessor :name, :font_weight, :font_style, :text_underline_style
      attr_accessor :data_style_name
      attr_reader   :style_family

      def initialize( name, attributes={} )
        @name                 = name
        @font_weight          = attributes[ :font_weight          ]
        @font_style           = attributes[ :font_style           ]
        @text_underline_style = attributes[ :text_underline_style ]
        @data_style_name      = attributes[ :data_style_name      ]

        @style_family = 'table-cell'
      end

    end

  end

end
