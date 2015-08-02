module Fenix::Store
  class Install < Base
    belongs_to :host
    belongs_to :package
    belongs_to :repository
    belongs_to :event

    #params: repository_url, package_version, package_name, instead_of(title),





    end
end
