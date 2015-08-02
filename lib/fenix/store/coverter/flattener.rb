#TODO: move it to fenix-transport gem
class Fenix::Store::Converter::Flattener
  class << self
    def event(data)
      _copy_fields(data, ['comment', 'installer', 'params'])
    end

    def installs(data)
      data['installs'].map{|i|_install i}
    end

    def sources(data)
      data['sources'].map{|i|_source i}
    end

    protected
    def _install(data)
      _copy_fields data, ['title', 'removed', 'params', 'package_id', 'repository_id']
    end

    def _source(data)
      _copy_fields data, ['url', 'installer', 'installer']
    end

    def _copy_fields(from, fields)
      Hash[fields.filter{|i|from.has_key?(i) && !from[i].nil?}.map{|i|[i, from[i]]}]
    end
  end
end