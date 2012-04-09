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

require File.expand_path( '../../../src/document_file',     __FILE__ )
require File.expand_path( '../../../src/elements/document', __FILE__ )
require File.expand_path( '../../../helpers/helpers',       __FILE__ )

require 'tempfile'

module DocumentFileSpecHelper

  def create_tempfile
    with_tempfile {}
  end

  def stub_class_initializer( klazz )
    class_instance = klazz.new

    klazz.stub!( :new ).and_return( class_instance )

    class_instance
  end

end

describe SpreadBase::DocumentFile do

  include DocumentFileSpecHelper
  include SpreadBase::Helpers

  # :open
  #
  it "should open a document" do
    mock_codec    = stub_class_initializer( SpreadBase::DocumentFile::DEFAULT_CODEC )
    document_root = SpreadBase::Elements::Document.new

    mock_codec.should_receive( :decode ).with( 'i love pizza' ).and_return( document_root )

    with_tempfile( :content => 'i love pizza' ) do | document_file |
      actual_content   = SpreadBase::DocumentFile.new.open( document_file.path )
      expected_content = document_root

      actual_content.should equal( expected_content )
    end
  end

  # :save
  #
  it "should save a document" do
    mock_codec    = stub_class_initializer( SpreadBase::DocumentFile::DEFAULT_CODEC )
    document_root = SpreadBase::Elements::Document.new
    document_file = create_tempfile

    mock_codec.should_receive( :encode ).with( document_root, :prettify => true ).and_return( 'i also love my homemade milkshake' )

    SpreadBase::DocumentFile.new.save( document_root, document_file.path, :prettify => true )

    actual_content   = IO.read( document_file.path )
    expected_content = 'i also love my homemade milkshake'

    actual_content.should == expected_content
  end

end
