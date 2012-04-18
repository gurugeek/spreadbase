
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
    @style_4 = SAL::Style.new( 'KARAOKE',  :test => true )
  end

  before :each do
    @table = SAL::Table.new(
      'largo al factotum!!',
      [           @style_1,               nil  ],
      [ @style_2, 1,                      nil  ],
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

  it "should access a cell (CASE 1: Fixnum column identifier)" do
    @table[ 0, 0 ].should == 1
    @table[ 1, 0 ].should == nil
    @table[ 0, 1 ].should == Date.new
    @table[ 1, 1 ].should == 44.3
  end

  it "should access a cell (CASE 2: Literal column identifier)" do
    @table[  9,   0 ] = 'ju-jitsu'
    @table[ 10,   0 ] = 'krasto'
    @table[ 25,   0 ] = 'zuzzurellone'
    @table[ 28,   0 ] = 'a-ha!!'
    @table[ 1023, 0 ] = 'mieeeeezzega!!!'

    @table[  'a',  0 ].should == 1
    @table[  'B',  0 ].should == nil
    @table[  'j',  0 ].should == 'ju-jitsu'
    @table[  'k',  0 ].should == 'krasto'
    @table[  'z',  0 ].should == 'zuzzurellone'
    @table[ 'ac',  0 ].should == 'a-ha!!'
    @table[ 'AMJ', 0 ].should == 'mieeeeezzega!!!'
  end

  it "should set a cell" do
    @table[ 'A', 0 ] = 10
    @table[ 'B', 1 ] = [ 2, @style_1 ]

    @table[ 'A', 0 ].should == 10
    @table[ 'B', 1 ].should == 2

    @table.cell_style( 'A', 0 ).should == nil
    @table.cell_style( 'B', 1 ).should == @style_1
  end

  it "should access a row" do
    @table.row( 0 ).should == [ 1,        nil  ]
    @table.row( 1 ).should == [ Date.new, 44.3 ]
  end

  it "should delete a row" do
    @table.delete_row( 0 )

    @table.row( 0 ).should == [ Date.new, 44.3 ]

    @table.row_style( 0 ).should == @style_3
  end

  it "should insert a row (CASE 1: equal/less values than the columns number)" do
    @table.insert_row( 1, [ @style_4, 34, [ 'abc', @style_2 ] ] )

    @table.data.size.should == 3

    @table.row( 1 ).should == [ 34,       'abc' ]
    @table.row( 2 ).should == [ Date.new, 44.3  ]

    @table.row_style( 1 ).should == @style_4

    @table.cell_style( 1, 0 ).should == nil
    @table.cell_style( 1, 1 ).should == @style_2
  end

  it "should insert a row (CASE 2: more values than the columns number)" do
    @table.insert_row( 4, [ @style_4, 34, [ 'abc', @style_2 ] ] )

    @table.data.size.should == 5

    @table.row( 2 ).should == [ nil, nil ]
    @table.row( 3 ).should == [ nil, nil ]

    @table.row( 4 ).should == [ 34, 'abc' ]
  end

  it "should insert a row (CASE 3: less values than the columns number)" do
    @table.insert_row( 1, [ 34 ] )

    @table.data.size.should == 3

    @table.row( 1 ).should == [ 34, nil ]
  end

  it "should access a column" do
    @table.column( 0 ).should == [ 1,   Date.new ]
    @table.column( 1 ).should == [ nil, 44.3     ]
  end

  it "should delete a column" do
    @table.delete_column( 0 )

    @table.column( 0 ).should == [ nil, 44.3 ]

    @table.column_style( 0 ). should == nil
  end

  it "should insert a column (CASE 1: equal/less values than the rows number)" do
    @table.insert_column( 1, [ @style_4, 34, [ 'abc', @style_2 ] ] )

    @table.data.size.should == 2

    @table.row( 0 ).should == [ 1,        34,    nil  ]
    @table.row( 1 ).should == [ Date.new, 'abc', 44.3 ]

    @table.cell_style( 1, 1 ).should == @style_2
  end

  it "should insert a column (CASE 2: more values than the rows number)" do
    @table.insert_column( 1, [ @style_4, 34, [ 'abc', @style_2 ], 1.1 ] )

    @table.data.size.should == 3

    @table.row( 0 ).should == [ 1,        34,    nil  ]
    @table.row( 1 ).should == [ Date.new, 'abc', 44.3 ]
    @table.row( 2 ).should == [ nil,      1.1,   nil  ]
  end

  it "should insert a column (CASE 3: less values than the rows number)" do
    @table.insert_column( 1, [ @style_4, 34 ] )

    @table.data.size.should == 2

    @table.row( 0 ).should == [ 1,        34,  nil  ]
    @table.row( 1 ).should == [ Date.new, nil, 44.3 ]

    @table.cell_style( 1, 1 ).should == nil
  end

  it "should return a column style" do
    @table.column_style( 0 ).should == @style_1
    @table.column_style( 1 ).should == nil
  end

  it "should return a row style" do
    @table.row_style( 0 ).should == @style_2
    @table.row_style( 1 ).should == @style_3
  end

  it "should return a cell style" do
    @table.cell_style( 0, 1 ).should == @style_4
    @table.cell_style( 1, 1 ).should == nil
  end

  it "should set a column style" do
    @table.set_column_style( 0, nil      )
    @table.set_column_style( 1, @style_2 )

    @table.column_style( 0 ).should == nil
    @table.column_style( 1 ).should == @style_2
  end

  it "should set a row style" do
    @table.set_row_style( 0, @style_3 )
    @table.set_row_style( 1, nil      )

    @table.row_style( 0 ).should == @style_3
    @table.row_style( 1 ).should == nil
  end

  it "should set a cell style" do
    @table.set_cell_style( 0, 1, nil      )
    @table.set_cell_style( 1, 1, @style_4 )

    @table.cell_style( 0, 1 ).should == nil
    @table.cell_style( 1, 1 ).should == @style_4
  end

end
