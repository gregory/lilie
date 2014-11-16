Dragonfly.app(:lilie).configure do |c|
# Here are the Insta Hipster filters: https://github.com/paulasmuth/hipster_filters
  processor :brightness_contrast do |content, *args|
    raise ArgumentError, "argument must be of the format '<int>[%]x<int>[%]'" unless args[0] =~ /^-?\d+%?(x-?\d+%?)?$/
    content.process! :convert, "-brightness-contrast #{args[0]}"
  end

  processor :watermark do |content, *args|
    opacity = args[0] || 20 #0-100 where 0 is opaque
    default_file = File.new(File.join(ROOT_PATH, 'images', 'logo.png')).path
    img_properties = content.analyse(:image_properties)

    # uses the source image dimensions to resize the watermark with
    watermark_resize = "#{img_properties['width']}x#{img_properties['height']}<"
    content.process! :convert, "#{default_file} -resize #{watermark_resize} -compose dissolve -define compose:args=#{opacity} -composite"
  end

  processor :saturation do |content, *args|
    raise ArgumentError, "percentage must be a positive integer" unless args[0] =~ /^\d+$/
    content.process! :convert, "-modulate 100,#{args[0]}"
  end

  processor :resize_with_blur do |content, *args|
    content.process! :convert, "-filter Gaussian -resize #{args[0]}"
  end

  processor :tilt_shift do |content, *args|
    coefficients = '4,-4,1' if arg[0] == 'true'
    raise ArgumentError, "coefficients must be of the format '<decimal>,<decimal>,<decimal>'" unless coefficients =~ /^(-?\d+(\.\d+)?,){2}-?\d+(\.\d+)?$/

    # note: can be made faster by decreasing sigma passed to option:compose:args
    action = "\\( +clone -sparse-color Barycentric '0,0 black 0,%h white' -function polynomial #{coefficients} \\) -compose Blur -set option:compose:args 8 -composite"
    content.process! :convert, action
  end

  processor :halftone do |content, *args|
    threshold = 50 if args[0] == 'true'
    content.process! :convert, "-white-threshold #{threshold.to_i}% -gaussian-blur 2 -ordered-dither 8x1"
  end

  # thanks to http://www.photoshopsupport.com/tutorials/or/cross-processing.html
  processor :cross_process do |content|
    content.process! :convert, "-channel Red -sigmoidal-contrast 6,50% -channel Blue -level 25%\\! -channel Green -sigmoidal-contrast 5,45% \\( +clone +matte -fill yellow -colorize 4% \\) -compose overlay -composite"
  end

  processor :jcn do |content|
    content.process! :greyscale
    @job = @job.halftone(99)
  end

  processor :glow do |content, *args|
    if args[0] == 'true'
      amount = 1.2
      softening = 20
    elsif args[0] =~ /^(\d+_\d+?),(\d+)$/ && $1.to_f >= 1.0 && $2.to_i >= 0
      amount = $1.to_f
      softening = $2
    else
      raise ArgumentError, "args must be of the form <amount(float)>,<softening(int)>"
    end

    content.process! :convert, "\\( +clone -evaluate multiply #{amount} -blur 0x#{softening} \\) -compose plus -composite"
  end

  processor :two_color do |content|
    content.process! :convert, "-background black -flatten +matte +dither -colors 2 -colorspace gray -contrast-stretch 0"
  end

  processor :to_webp do |content, *args|
    quality = args[0] || 50
    content.process! :convert, "-quality #{quality} -define webp:lossless=true", 'webp'
    content.ext = "webp"
  end

  processor :color_palette_swatch do |content, *args|
    count = 5 if args[0] == 'true'

    content.process! :convert, "-resize 600x600 -colors #{count} -unique-colors -scale 10000%", 'gif'
  end
end
