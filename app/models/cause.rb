class Cause < ActiveRecord::Base
	include NotDeleteable
	versioned
	
	attr_accessible :name, :user_ids, :deleted, :group_ids, :type, :uid, :fg_uuid, :fg_type_id, :alias, :abstract, :ein, :fg_parent_uuid, :address_line_1, :address_line_2, :address_line_3, :address_line_full, :city, :region, :postal_code, :county, :country, :address_full, :phone_number, :area_code, :url, :fg_category_code, :fg_category_title, :fg_category_description, :latitude, :longitude, :fg_revoked, :fg_locale_db_id

  before_validation :generate_uid, :get_fg_details #, :generate_name_placeholder

	validates :name, :presence => {message: ":: Oops - looks like there's been a problem.  Please try choosing a different cause.  Sorry 'bout that."}
  validates :uid, presence: true, uniqueness: { case_sensitive: true }

	has_and_belongs_to_many :users
  has_and_belongs_to_many :groups
	has_many :promotions
	has_many :shares
	has_many :serves

	def self.not_exists?(id)
		self.find(id)
		false
	rescue
		true
  end

  def self.cause_valid?(cause_uid)
    if cause_uid == nil
      false
    elsif cause_uid == ""
      false
    elsif self.find_by_uid(cause_uid) == nil
      false
    else
      true
    end
  end

  def self.get_cause_id(fg_uuid)
    if self.find_by_fg_uuid(fg_uuid)
      @cause = self.find_by_fg_uuid(fg_uuid)
    else
      @cause = Cause.create(type: "Single", fg_uuid: fg_uuid)
    end
    return @cause.id
  end

  protected
  def generate_uid
    if self.uid.nil? || self.uid == ""
      self.uid = loop do
        uid = SecureRandom.urlsafe_base64(8, false)
        break uid unless Cause.where(uid: uid).exists?
      end
    end
  end

  # protected
  # def generate_name_placeholder
  #   if self.name.nil? || self.name == ""
  #     self.name = "Name Placeholder: " + self.uid
  #   end
  # end

  protected
  def get_fg_details
    # if self.fg_uuid != "" and self.name == "Name Placeholder: " + self.uid
    if self.fg_uuid != "" && ( self.name == "" || self.name.nil? )
      uri = 'http://graphapi.firstgiving.com/v2/object/organization/' + self.fg_uuid
      response = RestClient.get uri, {:accept => :json}
      if response.include? "payload" and response.length > 12
        response = JSON.parse(response)
        self.name = response["payload"]["organization_name"]
        self.fg_type_id = response["payload"]["organization_type_id"].to_i
        self.alias = response["payload"]["organization_alias"]
        self.abstract = response["payload"]["organization_abstract"]
        self.ein = response["payload"]["government_id"].to_i
        self.fg_parent_uuid = response["payload"]["parent_organization_uuid"]
        self.address_line_1 = response["payload"]["address_line_1"]
        self.address_line_2 = response["payload"]["address_line_2"]
        self.address_line_3 = response["payload"]["address_line_3"]
        self.address_line_full = response["payload"]["address_line_full"]
        self.city = response["payload"]["city"]
        self.region = response["payload"]["region"]
        self.postal_code = response["payload"]["postal_code"]
        self.county = response["payload"]["county"]
        self.country = response["payload"]["country"]
        self.address_full = response["payload"]["address_full"]
        self.phone_number = response["payload"]["phone_number"]
        self.area_code = response["payload"]["area_code"]
        self.url = response["payload"]["url"]
        self.fg_category_code = response["payload"]["category_code"]
        self.fg_category_title = response["payload"]["category_title"]
        self.fg_category_description = response["payload"]["category_desription"]
        self.latitude = response["payload"]["latitude"]
        self.longitude = response["payload"]["longitude"]
        self.fg_revoked = response["payload"]["revoked"]
        self.fg_locale_db_id = response["payload"]["locale_db_id"]
      end
    end
  end


end
