module RImage
  module Formats
    struct Bitmap < Image
      getter file_length : Int32
      getter reserved1 : Int16, reserved2 : Int16
      getter color_planes : Int16, bits_per_pixel : Int16
      getter compression = Compression::RGB
      getter! image_size : Int32

      getter x_px_per_m : Int32?, y_px_per_m : Int32?
      getter colors : Int32?
      getter important_colors : Int32?

      def initialize(file : File)
        raise "Could not parse BMP file. Header incorrect" unless file.gets(2) == "BM"

        # Header
        @file_length = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
        @reserved1 = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        @reserved2 = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        data_start = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
        format = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)

        # Extended Header
        @width = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
        @height = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
        @color_planes = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        @bits_per_pixel = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        if format == 40
          @compression = Compression.from_value(file.read_bytes(Int32, IO::ByteFormat::LittleEndian))
          @image_size = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          @x_px_per_m = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          @y_px_per_m = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          @colors = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
          @important_colors = file.read_bytes(Int32, IO::ByteFormat::LittleEndian)
        end

        data_start = 54 unless data_start > 0 # Default
        @image_size = @width.not_nil! * @height.not_nil! * 3 if @image_size.nil? || @image_size == 0

        file.seek(data_start)
        @data = Bytes.new(image_size)
        file.read_fully(data)

        file.close
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
