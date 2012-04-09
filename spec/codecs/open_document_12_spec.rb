# encoding: UTF-8

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

require File.expand_path( '../../../lib/spreadbase', __FILE__ )
require File.expand_path( '../../spec_helpers',      __FILE__ )

require 'date'
require 'bigdecimal'

include SpecHelpers

# See testing notes.
#
describe SpreadBase::Codecs::OpenDocument12 do

  before :all do
    table_1 = SpreadBase::Table.new(
      'abc', [
        [ 1,      1.1,        T_BIGDECIMAL ],
        [ T_DATE, T_DATETIME, T_TIME       ],
        [ nil,    'a',        nil          ]
      ]
    )

    table_2 = SpreadBase::Table.new( 'cde' )

    @sample_document = SpreadBase::Document.new

    @sample_document.tables << table_1 << table_2
  end

  # :encode/:decode
  #
  it "should encode and decode the sample document" do
    document_archive = SpreadBase::Codecs::OpenDocument12.new.encode_to_archive( @sample_document )

    document = SpreadBase::Codecs::OpenDocument12.new.decode_archive( document_archive )

    assert_size( document.tables, 2 ) do | table_1, table_2 |

      table_1.name.should == 'abc'

      assert_size( table_1.data, 3 ) do | row_1, row_2, row_3 |

        assert_size( row_1, 3 ) do | value_1, value_2, value_3 |
          value_1.should == 1
          value_2.should == 1.1
          value_3.should == T_BIGDECIMAL
        end

        assert_size( row_2, 3 ) do | value_1, value_2, value_3 |
          value_1.should == T_DATE
          value_2.should == T_DATETIME
          value_3.should == T_DATETIME
        end

        assert_size( row_3, 3 ) do | value_1, value_2, value_3 |
          value_1.should == nil
          value_2.should == 'a'
          value_3.should == nil
        end

      end

      table_2.name.should == 'cde'

      assert_size( table_2.data, 0 )
    end
  end

  # Not worth testing in detail; just ensure that the pref
  #
  it "should encode the document with makeup (:prettify) - SMOKE" do
    formatter = stub_initializer( REXML::Formatters::Pretty )

    formatter.should_receive( :write )

    SpreadBase::Codecs::OpenDocument12.new.encode_to_archive( @sample_document, :prettify => true )
  end

  # Those methods are actually "utility" (read: testing) methods.
  #
  it "should encode/decode the content.xml - SMOKE" do
    content_xml = SpreadBase::Codecs::OpenDocument12.new.encode_to_content_xml( @sample_document )

    document = SpreadBase::Codecs::OpenDocument12.new.decode_content_xml( content_xml )

    assert_size( document.tables, 2 )
  end

  it "should handle the column widths"

  it "should handle utf-8: convert: 1.9 valid, 1.8 valid, 1.8 invalid"

end