require "./header"
require "./dib_header"

module RImage
  module Formats
    module Bitmap
      struct Image < RImage::Image
        getter header : Header
        getter dib_header : DibHeader

        def initialize(file : File)
          @header = Header.new(file)
          @dib_header = DibHeader.new(file)

          data_offset = header.data_offset > 0 ? header.data_offset : 54
          byte_size = if dib_header.image_size.nil? || dib_header.image_size == 0
                        (((dib_header.bits_per_pixel.to_i32 * width + 31) / 32) * 4) * height
                      else
                        dib_header.image_size.not_nil!
                      end

          file.seek(data_offset)
          @data = Bytes.new(byte_size)
          file.read_fully(data)

          file.close
        end

        def width
          @dib_header.width
        end

        def height
          @dib_header.height
        end
      end
    end
  end
end
