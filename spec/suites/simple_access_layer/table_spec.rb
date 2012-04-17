
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

require File.expand_path( '../../../../src/simple_access_layer/style', __FILE__ )
require File.expand_path( '../../../../src/simple_access_layer/table', __FILE__ )

# Table#data method is tested all over the suite, essentially.
#
describe SpreadBase::SimpleAccessLayer::Table do

  # see open_document_12_spec.rb comments
  #
  module SAL
    Style = SpreadBase::SimpleAccessLayer::Style
    Table = SpreadBase::SimpleAccessLayer::Table
  end

  before :all do
    @style_1 = SAL::Style.new( 'saverio!', :test => true )
    @style_2 = SAL::Style.new( 'enrico!',  :test => true )
    @style_3 = SAL::Style.new( 'mixy!',    :test => true )
    @style_4 = SAL::Style.new( 'KARAOKE',    :test => true )
  end

  before :each do
    @table = SAL::Table.new(
      'largo al factotum!!', [ @style_1, nil ],

      [ @style_2, 1,                     nil   ],
      [ @style_3, [ Date.new, @style_4 ], 44.3 ],
    )
  end

  it "should initialize with data" do
    expected_data = [
      [ 1,        nil  ],
      [ Date.new, 44.3 ]
    ]

    @table.data.should == expected_data
  end

  it "should initialize from a raw table"

  it "should access a cell (CASE 1: Fixnum column identifier)" do
    @table[ 0, 0 ].should == 1
    @table[ 1, 0 ].should == nil
    @table[ 0, 1 ].should == Date.new
    @table[ 1, 1 ].should == 44.3
  end

  it "should access a cell (CASE 2: Literal column identifier)" do
    @table[  9, 0 ] = 'ju-jitsu'
    @table[ 10, 0 ] = 'krasto'
    @table[ 25, 0 ] = 'zuzzurellone'
    @table[ 26, 0 ] = 'a-ha!!'

    @table[  'a', 0 ].should == 1
    @table[  'B', 0 ].should == nil
    @table[  'j', 0 ].should == 'ju-jitsu'
    @table[  'k', 0 ].should == 'krasto'
    @table[  'z', 0 ].should == 'zuzzurellone'
    @table[ 'aa', 0 ].should == 'a-ha!!'
  end

  it "should set a cell" do
    @table[ 'A', 0 ] = 10
    @table[ 'B', 1 ] = [ 2, @style_1 ]

    @table[ 'A', 0 ].should == 10
    @table[ 'B', 1 ].should == 2

    @table.cell_style( 'A', 0 ).should == nil
    @table.cell_style( 'B', 1 ).should == @style_1
  end

  it "should access a row"

  it "should delete a row"

  it "should insert a row (CASE 1: equal/less values than the columns number)"

  it "should insert a row (CASE 2: more values than the columns number)"

  it "should access a column"

  it "should delete a column"

  it "should insert a column (CASE 1: equal/less values than the rows number)"

  it "should insert a column (CASE 2: more values than the rows number)"

  it "should return a column style"

  it "should return a row style"

  it "should return a cell style"

  it "should set a column style"

  it "should set a row style"

  it "should set a cell style"

end
