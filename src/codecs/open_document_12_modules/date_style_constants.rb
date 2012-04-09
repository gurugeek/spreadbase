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

  module Codecs

    module OpenDocument12Modules

      module DateStyleConstants

        # Used when encoding - pretend we always use the same base style (MM/DD/YYYY)
        #
        BASE_STYLE = 'N36'

        # Patterns

        YEAR         = 'number:year'
        MONTH        = 'number:month'
        DAY          = 'number:day'
        HOURS        = 'number:hours'
        MINUTES      = 'number:minutes'
        SECOND       = 'number:seconds'
        AM_PM        = 'number:am-pm'

        DAY_OF_WEEK  = 'number:day-of-week'
        WEEK_OF_YEAR = 'number:week-of-year'
        QUARTER      = 'number:quarter'

        TEXT         = 'number:text'

        # Pattern attributes
        #
        LONG    = 'long'
        TEXTUAL = 'textual'

      end

    end

  end

end
