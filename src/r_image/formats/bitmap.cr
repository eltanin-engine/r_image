require "./bitmap/*"

module RImage
  module Formats
    module Bitmap
      def self.new(file : File)
        Image.new(file)
      end
    end
  end

  alias BMP = Formats::Bitmap::Image
  alias Bitmap = Formats::Bitmap::Image
end
