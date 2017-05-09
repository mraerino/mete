class Drink < ActiveRecord::Base

  validates_presence_of :name, :bottle_size, :price

  has_attached_file :logo, :styles => { :thumb => "100x100#" }, :default_style => :thumb
  validates_attachment_content_type :logo, :content_type => %w(image/jpeg image/jpg image/png)
  before_post_process :normalize_filename
  after_initialize :set_defaults, unless: :persisted?

  def as_json(options = nil)
    h = super(options)
    h["donation_recommendation"] = price # API compatibility
    h["logo_url"] = logo.url
    h
  end

  def v1
    h = as_json
    h['price'] = h['price'] / 100.0
    h['donation_recommendation'] = h['donation_recommendation'] / 100.0
    h
  end

  private

  def set_defaults
    self.price = 150
  end

  def normalize_filename
    extension = File.extname(logo_file_name).downcase
    self.logo.instance_write :file_name, "logo#{extension}"
  end

end
