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

require File.expand_path( '../../elements/style',      __FILE__ )
require File.expand_path( '../../elements/date_style', __FILE__ )

# This class merges the concepts of text and date styles into one.
#
module SpreadBase

  module SimpleAccessLayer

    class Style

      def initialize( name, attributes )
        raise "wm!"
      end

      def self.from_raw_style( raw_style )
        raise "wm!"
      end

    end

  end

end
