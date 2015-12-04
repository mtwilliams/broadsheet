# TODO(mtwilliams): Move into Tetrahedron.
class Broadsheet::Mailer
  module ClassMethods
    def mail(opts = {})
      fail unless opts.include? :to
       fail unless opts[:to].include? :address
      fail unless opts.include? :from
       fail unless opts[:from].include? :address
      fail unless opts.include? :subject
      fail unless opts.include? :template

      html = render(:html, opts[:template], opts[:bindings])
      plaintext = render(:txt, opts[:template], opts[:bindings])

      fail if (html.nil? and plaintext.nil?)

      Mail.new do
        message_id "<#{SecureRandom.uuid}@#{ENV['HOST']}>"

        # TODO(mtwilliams): Refactor out servcice-specific headers.
        headers 'X-MC-Tags' => opts[:template].to_s,
                'X-MC-Metadata' => %{\{"template":"#{opts[:template]}"\}},
                'X-MC-Important' => opts.fetch(:important, false),
                'X-PM-Tag' => opts[:template].to_s,
                'X-PM-KeepID' => true

        if opts[:to][:name]
          to "#{opts[:to][:name]} <#{opts[:to][:address]}>"
        else
          to opts[:to][:address]
        end
        if opts[:from][:name]
          from "#{opts[:from][:name]} <#{opts[:from][:address]}>"
        else
          from opts[:from][:address]
        end

        subject opts[:subject]

        text_part do
          body plaintext
        end

        html_part do
          body html
        end
      end
    end

    private
      class Bindings
        def initialize(bindings={})
          @bindings = bindings
        end

        def get_binding
          binding
        end

        private
          def respond_to_missing(method_name, include_private=false)
            @bindings.include? method_name
          end

          def method_missing(method_name, *args)
            @bindings[method_name]
          end
      end

      def render(type, template, bindings)
        engines = {:html => :erb, :txt => :erb}
        template = "#{Broadsheet.root}/app/broadsheet/mailers/templates/#{template}.#{type}.#{engines[type]}"
        case engines[type]
        when :erb
          bindings = Bindings.new(bindings).get_binding
          return ERB.new(File.read(template)).result(bindings) if File.exists?(template)
        else
          fail
        end
        nil
      end
  end

  def self.inherited(mailer)
    mailer.extend(ClassMethods)
  end
end
