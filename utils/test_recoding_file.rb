#!/usr/bin/env ruby

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

require File.expand_path( '../../src/document_file', __FILE__ )

def test_recoding_file( file_path )
  destination_file_path = file_path.sub( /\.ods$/, '.2.ods' )

  document = SpreadBase::DocumentFile.new.open( file_path )
  SpreadBase::DocumentFile.new.save( document, destination_file_path, :prettify => true )

  `openoffice.org3 #{ destination_file_path }`
end

if __FILE__ == $0
  file_path = ARGV[ 0 ] || raise( "Usage: test_recoding_file.rb <file>" )

  test_recoding_file( file_path )
end
