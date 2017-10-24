module RImage
  module Formats
    module Bitmap
      struct DibHeader
        # BITMAPCOREHEADER
        getter width : Int32
        getter height : Int32
        getter color_planes : Int16, bits_per_pixel : Int16

        # BITMAPINFOHEADER
        getter compression = Compression::RGB
        getter image_size : Int32?
        getter x_px_per_m : Int32?, y_px_per_m : Int32?
        getter colors : Int32?
        getter important_colors : Int32?

        def initialize(file : File)
          header_size = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)

          @width = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          @height = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          @color_planes = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          @bits_per_pixel = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)

          case header_size
          when 40 # BITMAPINFOHEADER
            @compression = Compression.from_value(file.read_bytes(Int32, IO::ByteFormat::LittleEndian))
            @image_size = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
            @x_px_per_m = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
            @y_px_per_m = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
            @colors = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
            @important_colors = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          end
        end

        enum Compression
          RGB       =  0
          RLE8      =  1
          RLE4      =  2
          BITFIELDS =  3
          JPEG      =  4
          PNG       =  5
          CMYK      = 11
          CMYK_RLE8 = 12
          CMYK_RLE4 = 13
        end
      end
    end
  end
end
