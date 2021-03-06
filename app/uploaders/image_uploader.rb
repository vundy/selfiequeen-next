# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  #storage :file
   storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :store_dimensions

  # version :blurred do
  #   process blur: [0, 8]
  # end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def blur(radius, sigma)
    manipulate! do |img|
      img.blur "#{radius}x#{sigma}"
      img = yield(img) if block_given?
      img
    end
  end

  private

  def store_dimensions
    if file && model
      model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
    end
  end
end
