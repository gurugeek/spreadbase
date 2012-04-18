
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

require File.expand_path( '../../../../src/simple_access_layer/document',                           __FILE__ )

describe SpreadBase::SimpleAccessLayer::Document do

  # See open_document_12_spec.rb
  #
  module SDL
    Document = SpreadBase::SimpleAccessLayer::Document
  end

  it "should initialize without a file" do
    document = SDL::Document.new

    document.tables.size.should == 1

    document.tables.first.name.should == SDL::Document::DEFAULT_TABLE_NAME
  end

  # # Another annoying (not worth) to test in detail
  # #
  # it "should save - SMOKE" do
  #   document = SDL::Document.new

  #   document.document_path = '/tmp/abc.ods'

  #   document.save
  # end

  it "should raise an error when trying to save without a filename" do
    document = SDL::Document.new

    lambda { document.save }.should raise_error( RuntimeError, "Document path not specified" )
  end

end
