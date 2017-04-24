class HomeController < ApplicationController
  before_action :handle_extra_data, only: [:image]

  def index
    puts "Inside the index action"
  end

  def image

    if (params[:size] == 'js' && params[:bg_color] == 'bootstrap')
      return nil
    end

    @image = Image.new(
      size: params[:size],
      bgcolor: params[:bg_color],
      fgcolor: params[:fg_color],
      text: params[:text],
      format: params[:format]
    )

    #begin
    @data = @image.image_data

      send_data @data, :type => "image/#{@image.format}", disposition: :inline
    #rescue Exception => ex
    #  puts "Awesome now"
    #end

    #respond_to do |format|
    #  format.html { render :image }
    #  format.jpg { render html: @image.inspect}
    #  format.jpeg { render html: @image.inspect}
    #  format.gif { render html: @image.inspect }
    #  format.png { render html: @image.inspect }
    #end

  end

private
  def handle_extra_data
    puts "Handling extra data"
    extra_data = params[:extra_data]

    if extra_data.nil?
      puts "No extra data received."
    else
      puts "Extra data has been received."
      if params[:extra_data] =~ /[0..9]/
        params[:size] += params[:extra_data]
      elsif attributes[:extra_data] =~ /a..zA..Z]/
        params[:format] += params[:extra_data]
      else
        extra_data_array = data.split("/") if data.include? "/"
        if (extra_data_array.kind_of? Array)
          if (extra_data_array.length == 3)
            params[:bg_color] = extra_data_array[1]
            params[:fg_color] = extra_data_array[2]
          end
          if (extra_data_array.length == 2)
            params[:fg_color] = extra_data_array[1]
          end
        else
          puts "Throwing away extra data value of #{extra_data}"
        end
      end
    end
  end

end
