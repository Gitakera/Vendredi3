require 'mail'

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => 'joseonetouch8@gmail.com',
            :password             => 'ramarosandy',
            :authentication       => 'plain',
            :enable_starttls_auto => true  }

Mail.defaults do
  delivery_method :smtp, options
end

Mail.deliver do
       to 'joseramarosandy@gmail.com'
     from 'joseonetouch8@gmail.com'
  subject 'Test'
     body 'Hurray!!! Test email!'
end