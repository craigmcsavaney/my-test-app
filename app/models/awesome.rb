class Awesome < ActiveRecord::Base

  def self.get_new_link_path(channel,target_url)
      url = Awesm::Url.create(
        :channel => channel,
        :key => '477458cbea4e4dfd493b74589a97cbb90183698ff37a3f6d8c7278504a32495a',
        :tool => 'doLH2o',
        :url => target_url
        )

      return url.path
  end

end
