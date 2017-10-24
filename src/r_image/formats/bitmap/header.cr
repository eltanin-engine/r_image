module RImage
  module Formats
    module Bitmap
      struct Header
        getter file_length : Int32
        getter reserved1 : Int16, reserved2 : Int16
        getter data_offset : Int32

        def initialize(file : File)
          raise "Could not parse BMP file. Header incorrect" unless file.gets(2) == "BM"
          @file_length = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          @reserved1 = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          @reserved2 = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          @data_offset = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
        end
      end
    end
  end
end
