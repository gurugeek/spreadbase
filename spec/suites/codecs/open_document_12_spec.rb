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

require File.expand_path( '../../../../src/codecs/open_document_12',                              __FILE__ )
require File.expand_path( '../../../../src/codecs/open_document_12_modules/style_constants',      __FILE__ )
require File.expand_path( '../../../../src/codecs/open_document_12_modules/date_style_constants', __FILE__ )
require File.expand_path( '../../../../src/elements/document',                                    __FILE__ )
require File.expand_path( '../../../../src/elements/style',                                       __FILE__ )
require File.expand_path( '../../../../src/elements/date_style',                                  __FILE__ )
require File.expand_path( '../../../../src/elements/table',                                       __FILE__ )
require File.expand_path( '../../../../src/elements/column',                                      __FILE__ )
require File.expand_path( '../../../../src/elements/row',                                         __FILE__ )
require File.expand_path( '../../../../src/elements/cell',                                        __FILE__ )

module SpreadBase::Codecs::OpenDocument12SpecHelper

  def create_sample_document
    SB::Document.new(
      :styles  => [
        SB::Style.new(
          'st1',
          :font_weight          => SB::BOLD,
          :font_style           => SB::ITALIC,
          :text_underline_style => SB::UNDERLINED,
        ),
        SB::DateStyle.new(
          SB::BASE_STYLE,
          [ SB::DAY_OF_WEEK, SB::TEXTUAL ],
          '/',
          [ SB::MONTH, SB::TEXTUAL ],
        ),
      ],
      :tables => [
        SB::Table.new(
          'abc',
          :columns => [
            SB::Column.new( :default_cell_style => 'st1' ),
          ],
          :rows => [
            SB::Row.new(
              :style => 'st1',
              :cells => [
                SB::Cell.new,
                SB::Cell.new( :text => 'pizza',    :value_type => 'string' ),
                SB::Cell.new( :text => '04/10/12', :value_type => 'date', :date_value => '2012-04-10' ),
              ],
            ),
            SB::Row.new
          ]
        ),
        SB::Table.new( nil )
      ],
    )
  end

  def encoded_sample_document
    sample_document = create_sample_document

    SpreadBase::Codecs::OpenDocument12.new.encode( sample_document )
  end

  def assert_size( collection, expected_size )
    collection.size.should == expected_size

    yield( *collection ) if block_given?
  end

end

# See testing notes.
#
describe SpreadBase::Codecs::OpenDocument12 do

  # most likely, due to the block nature of the rspec suites, including a module
  # doesn't make its constant available to the UT blocks.
  #
  module SB

    Document    = SpreadBase::Elements::Document
    Table       = SpreadBase::Elements::Table
    Row         = SpreadBase::Elements::Row
    Cell        = SpreadBase::Elements::Cell
    Column      = SpreadBase::Elements::Column
    Style       = SpreadBase::Elements::Style
    DateStyle   = SpreadBase::Elements::DateStyle

    BOLD        = SpreadBase::Codecs::OpenDocument12Modules::StyleConstants::BOLD
    UNDERLINED  = SpreadBase::Codecs::OpenDocument12Modules::StyleConstants::UNDERLINED
    ITALIC      = SpreadBase::Codecs::OpenDocument12Modules::StyleConstants::ITALIC

    BASE_STYLE  = SpreadBase::Codecs::OpenDocument12Modules::DateStyleConstants::BASE_STYLE
    DAY_OF_WEEK = SpreadBase::Codecs::OpenDocument12Modules::DateStyleConstants::DAY_OF_WEEK
    MONTH       = SpreadBase::Codecs::OpenDocument12Modules::DateStyleConstants::MONTH
    YEAR        = SpreadBase::Codecs::OpenDocument12Modules::DateStyleConstants::YEAR
    TEXT        = SpreadBase::Codecs::OpenDocument12Modules::DateStyleConstants::TEXT

    LONG        = SpreadBase::Codecs::OpenDocument12Modules::DateStyleConstants::LONG
    TEXTUAL     = SpreadBase::Codecs::OpenDocument12Modules::DateStyleConstants::TEXTUAL

  end

  include SpreadBase::Codecs::OpenDocument12SpecHelper

  it "should employ more data types in the main codec test: percentage, formula, ..."

  # :encode/:decode
  #
  it "should encode and decode the sample document" do
    encoded_document = encoded_sample_document

    # assert_size is cool beyond any argument about the imperfect name.
    #
    document = SpreadBase::Codecs::OpenDocument12.new.decode( encoded_document )

    assert_size( document.styles, 2 ) do | style_1, style_2 |

      style_1.name.should == 'st1'
      style_1.font_weight.should == SB::BOLD
      style_1.font_style.should == SB::ITALIC
      style_1.text_underline_style.should == SB::UNDERLINED

      style_2.name.should == SB::BASE_STYLE

      assert_size( style_2.patterns, 3 ) do | pattern_1, pattern_2, pattern_3 |

        pattern_1.should == [ SB::DAY_OF_WEEK, SB::TEXTUAL ]
        pattern_2.should == '/'
        pattern_3.should == [ SB::MONTH, SB::TEXTUAL ]

      end

    end

    assert_size( document.tables, 2 ) do | table_1, table_2 |

      table_1.name.should == 'abc'

        assert_size( table_1.rows, 2 ) do | row_1, row_2 |

          assert_size( row_1.cells, 3 ) do | cell_1, cell_2, cell_3 |
            cell_1.text.should be_nil
            cell_1.value_type.should be_nil
            cell_1.date_value.should be_nil

            cell_2.text.should == 'pizza'
            cell_2.value_type.should == 'string'
            cell_2.date_value.should be_nil

            cell_3.text.should == '04/10/12'
            cell_3.value_type.should == 'date'
            cell_3.date_value.should == '2012-04-10'
          end

          assert_size( row_2.cells, 0 )

        end

      table_2.name.should be_nil

      assert_size( table_2.rows, 0 )
    end
  end

  it "should encode the document with makeup (:prettify)"

  it "should decode the sample document, directly from the content.xml content"

end
