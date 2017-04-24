class Image
  include ActiveModel::Model

  DEFAULT_HSIZE = "300"
  DEFAULT_VSIZE = "250"
  DEFAULT_BGCOLOR = "cccccc"
  DEFAULT_FGCOLOR = "999999"
  DEFAULT_FONT = "Verdana"

  attr_accessor :size, :format, :bgcolor, :fgcolor, :text
  attr_reader :hsize, :vsize, :font_size

  def initialize(attributes={})
    super

    @size ||= "#{DEFAULT_HSIZE}x#{DEFAULT_VSIZE}"
    @hsize, @vsize = parse_size(@size)
    @bgcolor ||= DEFAULT_BGCOLOR
    @fgcolor ||= DEFAULT_FGCOLOR
    @text ||= "#{@hsize}x#{@vsize}"
    @format = parse_format(attributes[:format])
    @font_size = @hsize / 10
  end

  def image_data
    command = "magick -size \"#{@hsize}x#{@vsize}\" canvas:\"##{@bgcolor}\" #{@format}:- 2> /dev/null | magick - -font #{DEFAULT_FONT} -pointsize #{@font_size} -fill \"##{@fgcolor}\" -gravity center -draw \"text 0,0 '#{@text}'\" #{@format}:- 2> /dev/null"
    puts command
    data = `#{command}`

    # if $?.success?
      data
    # else
    #   throw "Awesome"
    # end

  end

private
  def parse_format(format)
    case format
    when 'gif'
      "gif"
    when 'jpg'
      "jpg"
    when 'jpeg'
      "jpg"
    when 'png'
      "png"
    else
      "gif"
    end
  end

  def parse_size(size)
    if !size.downcase.include? "x"
      begin
        size = Integer(size)
        size = "#{size}x#{size}"
      rescue Exception => e
        size = "#{DEFAULT_HSIZE}x#{DEFAULT_VSIZE}"
      end      
    end
  
    hsize, vsize = size.split("x")

    hsize = Integer(hsize) rescue "300"
    vsize = Integer(vsize) rescue "250"

    return hsize, vsize
  end
end
