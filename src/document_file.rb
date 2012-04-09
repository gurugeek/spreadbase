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

require File.expand_path( '../codecs/open_document_12' , __FILE__ )

module SpreadBase

  class DocumentFile

    DEFAULT_CODEC = Codecs::OpenDocument12 

    def open( document_path )
      document_raw = IO.binread( document_path )

      DEFAULT_CODEC.new.decode( document_raw )
    end

    def save( document_root, document_path, options={} )
      document_raw = DEFAULT_CODEC.new.encode( document_root, options )

      IO.write( document_path, document_raw )
    end

  end

end
