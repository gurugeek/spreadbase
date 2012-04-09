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

require 'zipruby'
require 'rexml/document'

require File.expand_path( '../../elements/document', __FILE__ )
require File.expand_path( '../../elements/style',    __FILE__ )
require File.expand_path( '../../elements/table',    __FILE__ )
require File.expand_path( '../../elements/column',   __FILE__ )
require File.expand_path( '../../elements/row',      __FILE__ )
require File.expand_path( '../../elements/cell',     __FILE__ )

require File.expand_path( '../open_document_12_modules/encoding', __FILE__ )
require File.expand_path( '../open_document_12_modules/decoding', __FILE__ )

module SpreadBase

  module Codecs

    class OpenDocument12

      MANIFEST_XML = %Q[\
<?xml version="1.0" encoding="UTF-8"?>
<manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.2">
  <manifest:file-entry manifest:media-type="application/vnd.oasis.opendocument.spreadsheet" manifest:version="1.2" manifest:full-path="/"/>
  <manifest:file-entry manifest:media-type="text/xml" manifest:full-path="content.xml"/>
</manifest:manifest>]

      include OpenDocument12Modules::Encoding
      include OpenDocument12Modules::Decoding

      # F*** rubyzip, which for purely sadistic reasons, doesn't support in-memory archives.
      # In-memory archives writing is already supported, but hidden. In-memory reading is not
      # possible, but private parts (ahem...) of the code support it, but are unused.
      #
      def encode( document, options={} )
        prettify = options[ :prettify ]

        document_xml_root = encode_document( document )
        document_buffer   = prettify ? pretty_xml( document_xml_root ) : document_xml_root.to_s

        zip_buffer = ''

        Zip::Archive.open_buffer( zip_buffer, Zip::CREATE ) do | zip_file |
          zip_file.add_dir( 'META-INF' )

          zip_file.add_buffer( 'META-INF/manifest.xml', MANIFEST_XML    );
          zip_file.add_buffer( 'content.xml',           document_buffer );
        end

        zip_buffer
      end

      # WATCH OUT! Don't forget to open If zip_buffer has been read from the disk, it _must_ have been
      # read using the 'rb' mode.
      #
      # hierarchy:
      #
      #   office:document-content/office:body/office:spreadsheet/table:table
      #     table:table-column
      #     table:table-row
      #       table:table-cell
      #         text:p
      #
      def decode( zip_buffer )
        content_xml_data = Zip::Archive.open_buffer( zip_buffer ) do | zip_file |
          zip_file.fopen( 'content.xml' ) { | file | file.read }
        end

        decode_content_xml( content_xml_data )
      end  

      def decode_content_xml( content_xml_data )
        root_node = REXML::Document.new( content_xml_data )

        decode_document( root_node )
      end

      private

      def pretty_xml( document )
        buffer = ""

        xml_formatter = REXML::Formatters::Pretty.new
        xml_formatter.compact = true
        xml_formatter.write( document, buffer )

        buffer
      end

    end

  end

end
