module RImage
  abstract struct Image
    getter! width : Int32?
    getter! height : Int32?
    getter! data : Bytes?

    def initialize(file_path : String)
      initialize(File.open(file_path))
    end

    abstract def initialize(file : File)
  end
end
