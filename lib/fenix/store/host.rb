module Fenix::Store
  class Host < Base
    has_many :events
    has_many :sources
    has_many :installs
    has_many :repositories, through: :sources
    #params: system_installer {apt|yum...}

    def set_sources srcs
      seen = (Repository.find_or_create_several(srcs.filter{|s|!s.has_key?('repository_id')}).map{|id| {'repository_id' => id}} +
          srcs.filter{|s|s.has_key?('repository_id')}.map{|s|{'repository_id' => s['repository_id']}})
          .map{|hs| sources.find_or_create_by(hs).id}
      sources.where(id: seen).update_all seen_at: Time.now, unseen: 0
      sources.where(id: sources.pluck(:id) - seen).update_all 'unseen = unseen+1'
      1
    end


    def install insts, event=nil
      event.save unless event.nil? || event.saved?
      installs.create(find_new_installs(insts).map{|l|l+{host_id: id, event_id: event.nil?? 0 : event.id}})
    end

    private

    def find_new_installs insts
      insts.each_slice(100).map{|list|
        list = make_hash list, 'titile'
        old_titles = installs.where({title: list.keys, removed:false}).pluck(:title)
        list = list.except(*old_titles).values if old_titles.count > 0
        list
      }.flatten
    end




    def make_hash list, key
      Hash[[list.map{|l| [l[key], l]}]]
    end

    end
end
