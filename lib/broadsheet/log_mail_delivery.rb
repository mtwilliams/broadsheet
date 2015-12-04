require 'mail'
require 'mail/check_delivery_params'

class Broadsheet::LogMailDelivery
  include Mail::CheckDeliveryParams

  attr_accessor :settings

  def initialize(settings={})
    @settings = settings.dup
    @file_delivery_method = Mail::FileDelivery.new(location: "#{Broadsheet.root}/.cache/mail")
  end

  def deliver!(mail)
    check_delivery_params(mail)

    puts <<-EOF
      === Mail #{'%-65s' % mail.message_id} ===
      To: #{mail.to}
      From: #{mail.from}
      ------------------------------------------------------------------------------
      #{mail.text_part}
      ==============================================================================
    EOF

    @file_delivery_method.deliver!(mail)
  end
end
