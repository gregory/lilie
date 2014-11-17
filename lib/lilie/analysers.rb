Dragonfly.app(:lilie).configure do |c|
  analyser :shot_at do |content|
    exif_date = content.shell_eval { |path| "identify -format '%[EXIF:DateTime]' #{path}" }
    exif_date.blank?  ? DateTime.now : DateTime.strptime(exif_date, "%Y:%m:%d %H:%M:%S")
  end

  analyser :fingerprint do |content|
    content.shell_eval { |path| "identify -format '%#' #{path}" }
  end

  analyser :color_palette do |temp_object, num_colors|
    num_colors = num_colors.blank? ? Magickly::DEFAULT_PALETTE_COLOR_COUNT : num_colors.to_i
    output = `convert #{temp_object.path} -resize 600x600 -colors #{num_colors} -format %c -depth 8 histogram:info:-`

    palette = []
    output.scan(/\s+(\d+):[^\n]+#([0-9A-Fa-f]{6})/) do |count, hex|
      palette << { :count => count.to_i, :hex => hex }
    end
    palette
  end
end
