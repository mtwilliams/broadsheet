class Broadsheet::Assets
  def self.revisioned(path)
    @manifest ||= if Broadsheet.env.production?
      JSON.parse(File.read("#{Broadsheet.root}/public/assets/manifest.json"))
    else
      {}
    end
    "/assets/#{@manifest.fetch(path, path)}"
  end

  def self.server
    @server ||= begin
      root = "#{Broadsheet.root}/public/assets"
      not_found = Proc.new {|_| [404, {}, []]}
      Rack::Static.new(not_found, root: root, urls: [""])
    end
  end
end
