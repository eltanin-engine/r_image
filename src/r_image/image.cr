module RImage
  abstract struct Image
    getter! width : Int32
    getter! height : Int32
    getter! data : Bytes

    abstract def initialize(file : File)

    def self.new(file_path : String)
      new(File.open(file_path))
    end
  end
end
