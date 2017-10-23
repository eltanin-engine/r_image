require "./spec_helper"

describe RImage do
  describe "Bitmap" do
    it "loads bitmap file" do
      image = RImage::Formats::Bitmap.new(File.open("./spec/images/bitmap.bmp"))
      image.width.should eq(227)
      image.height.should eq(149)
      image.data.size.should eq(image.image_size)
      (image.data.size % 3).should eq(0)
    end
  end
end
