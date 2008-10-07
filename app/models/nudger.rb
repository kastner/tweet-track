class Nudger < ActionMailer::Base
  def send_nudge(to, mail_body)
    recipients to
    from %q|"Trackstat Nudger" <nudge@trackstat.us>|
    subject 'Keep going!'
    body mail_body
  end
end
