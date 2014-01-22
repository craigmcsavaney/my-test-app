class ContactMessage < ActiveRecord::Base
	has_no_table

	attr_accessible :first_name, :last_name, :phone, :email, :message

	column :first_name, :string
	column :last_name, :string
	column :phone, :string
	column :email, :string
	column :message, :string

   	validates :first_name, presence: true
   	validates :last_name, presence: true
   	validates :email, presence: true
   	validates :message, presence: true

   	def self.post_contact_message(firstname, lastname, phone, email, message)
      uri = 'http://www.hydrapouch.com/causebutton/crm/modules/Webforms/capture.php?'
      a = 'publicid'
      b = 'be33dece7a77ce22229b1027653aeebe'
      c = 'name'
      d = 'ContactUs'
      e = 'leadsource[]'
      f = 'ContactUs'
      g = 'leadstatus[]'
      h = 'Open'
      i = 'returnurl'
      j = ''
      k = 'firstname'
      l = 'lastname'
      m = 'phone'
      n = 'email'
      o = 'label:Message'
      query = {a => b, c => d, e => f, g => h, i => j, k => firstname, l => lastname, m => phone, n => email, o => message}.to_query
      uri += query
      response = RestClient.get uri
      if response.include? "error"
      	return false
      else
      	return true
      end
      # if response.include? "payload" and response.length > 12
      #   response = JSON.parse(response)
      #   self.name = response["payload"]["organization_name"]
      #   self.fg_type_id = response["payload"]["organization_type_id"].to_i
      #   self.alias = response["payload"]["organization_alias"]
      #   self.abstract = response["payload"]["organization_abstract"]
      #   self.ein = response["payload"]["government_id"].to_i
      #   self.fg_parent_uuid = response["payload"]["parent_organization_uuid"]
      #   self.address_line_1 = response["payload"]["address_line_1"]
      #   self.address_line_2 = response["payload"]["address_line_2"]
      #   self.address_line_3 = response["payload"]["address_line_3"]
      #   self.address_line_full = response["payload"]["address_line_full"]
      #   self.city = response["payload"]["city"]
      #   self.region = response["payload"]["region"]
      #   self.postal_code = response["payload"]["postal_code"]
      #   self.county = response["payload"]["county"]
      #   self.country = response["payload"]["country"]
      #   self.address_full = response["payload"]["address_full"]
      #   self.phone_number = response["payload"]["phone_number"]
      #   self.area_code = response["payload"]["area_code"]
      #   self.url = response["payload"]["url"]
      #   self.fg_category_code = response["payload"]["category_code"]
      #   self.fg_category_title = response["payload"]["category_title"]
      #   self.fg_category_description = response["payload"]["category_desription"]
      #   self.latitude = response["payload"]["latitude"]
      #   self.longitude = response["payload"]["longitude"]
      #   self.fg_revoked = response["payload"]["revoked"]
      #   self.fg_locale_db_id = response["payload"]["locale_db_id"]
      # end
  	end

end

