class Broadsheet::Assets
  def self.revisioned(path)
    @manifest ||= if Broadsheet.env.production?
      JSON.parse(File.read("#{Broadsheet.root}/.cache/public/manifest.json"))
    else
      {}
    end
    "/#{@manifest.fetch(path, path)}"
  end

  def self.server
    root = if Broadsheet.env.production?
             "#{Broadsheet.root}/.cache/public"
           else
             "#{Broadsheet.root}/public"
           end
    @server ||= Rack::Static.new(Proc.new {|_| [404, {}, []]}, root: root, urls: [""])
  end
end
