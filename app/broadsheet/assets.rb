class Broadsheet::Assets
  def self.manifest
    @manifest ||= begin
      # TODO(mtwilliams): Refactor into Broadsheet::Assets::ManifestGenerator.
      require 'digest/sha1'
      Hash[%w{bundle.js bundle.css}.map do |bundle|
        contents = File.read("#{Broadsheet.root}/public/assets/#{bundle}")
        hash = Digest::SHA1.hexdigest(contents)
        [bundle, "#{bundle}?#{hash}"]
      end]
    end
  end

  def self.revisioned(path)
    "/assets/#{self.manifest.fetch(path, path)}"
  end

  def self.server
    @server ||= begin
      root = "#{Broadsheet.root}/public/assets"
      not_found = Proc.new {|_| [404, {}, []]}
      Rack::Static.new(not_found, root: root, urls: [""])
    end
  end
end
