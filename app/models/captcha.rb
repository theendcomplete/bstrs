# require 'RMagick'
include Magick
class Captcha < ApplicationRecord
  belongs_to :request_response, optional: true
  has_one_attached :image
  serialize :request_params, Hash
  serialize :result, JSON

  # Basic image processing gets us to a black and white image
  # with most background removed
  def remove_background(im)
    im = ImageList.new(im.image)
    im.display
    im = im.equalize
    im = im.threshold(Magick::MaxRGB * 0.09)

    # the above processing leaves a black border.  Remove it.
    im = im.trim '#000'
    im
  end

  # Consider a pixel "black enough"?  In a grayscale sense.
  def black?(p)
    return p.intensity == 0 || (Magick::MaxRGB.to_f / p.intensity) < 0.5
  end


  # True iff [x,y] is a valid pixel coordinate in the image
  def in_bounds?(im, x, y)
    return x >= 0 && y >= 0 && x < im.columns && y < im.rows
  end


  # Returns new image with single-pixel "islands" removed,
  #   see: Conway's game of life.
  def despeckle(im)
    xydeltas = [[-1, -1], [0, -1], [+1, -1],
                [-1, 0], [+1, 0],
                [-1, +1], [0, +1], [+1, +1]]

    j = im.dup
    j.each_pixel do |p, x, y|
      if black?(p)
        island = true

        xydeltas.each do |dx2, dy2|
          if in_bounds?(j, x + dx2, y + dy2) &&
              black?(j.pixel_color(x + dx2, y + dy2))
            island = false
            break
          end
        end

        im = im.color_point(x, y, '#fff') if island

      end
    end

    im
  end
end
