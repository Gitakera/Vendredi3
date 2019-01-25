require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'mail'

#townhall_url
townhall_url="http://annuaire-des-mairies.com/60/"
class Adresse_mail
attr_accessor :tab_oise, :tab_orne, :tab_calais

	def get_townhall_email(townhall_url)
		nom_pret=[]
		lien_pret=[]

		adresse = Nokogiri::HTML(open("#{townhall_url}"))
		a = adresse.css('td')[7].text
		return a

	end

	def oise_town_urls
		f = 0
		oise_town_urls = []
		oise_town_urls[0] = "http://annuaire-des-mairies.com/oise.html"
		oise_town_urls[1] = "http://annuaire-des-mairies.com/oise-2.html"
		oise_town_urls[2] = "http://annuaire-des-mairies.com/oise-3.html"
		for i in oise_town_urls
			ville = Nokogiri::HTML(open(i))
			@tab_oise[f] =  ville.css('a[class="lientxt"]').to_s #tab_tout = lien de chaque ville
			f += 1 
		end
		print @tab_oise
	end


	def orne_town_urls
		orne_town_urls[0] = "http://annuaire-des-mairies.com/orne.html"
		orne_town_urls[1] = "http://annuaire-des-mairies.com/orne-2.html"
		for i in orne_town_urls
			ville = Nokogiri::HTML(open(i))
			@tab_orne << ville.css('a[class="lientxt"]')
			@tab_orne
		end
	end


	def pas_de_calais_town_urls
		pas_de_calais_town_urls[0] = "http://annuaire-des-mairies.com/pas_de_calais.html"
		pas_de_calais_town_urls[1] = "http://annuaire-des-mairies.com/pas_de_calais-2.html"
		pas_de_calais_town_urls[2] = "http://annuaire-des-mairies.com/pas_de_calais-3.html"
		for i in pas_de_calais_town_urls
			ville = Nokogiri::HTML(open(i))
			@tab_calais=ville.css('a[class="lientxt"]')
			@tab_calais
		end
	end


	def get_townhall_urls(oise_town_urls, ville)
#ville = Nokogiri::HTML(open(val_d_oise_town_urls))

		u=0
		lien_pret=[]

		for i in @tab_tout
			#puts i
			result=i.to_s
			result=/[http](.*)[html]/.match(result).to_s.gsub('href=".','http://annuaire-des-mairies.com').gsub('txt" ','')
			lien_pret[u]=result
			#puts result
			u=u+1

		end


		return lien_pret
end

def nom_pret
	u=0
	nom_pret=[]
	for i in @tab_tout
		#puts i
		result=i.to_s
		result=/[>](.*)[<]/.match(result).to_s.gsub('>','').gsub('<','')
		nom_pret[u]=result
		
		u=u+1

	end
end
#puts nom_pret
#ville = Nokogiri::HTML(open(val_d_oise_town_urls))
#nom_pret = ville.css('a[class="lientxt"]').text
def lien_pret

	lien_pret=get_townhall_urls(oise_town_urls,ville)
	mail_pret=[]
	myash=Hash.new
	t=0
	for i in lien_pret
		
		u = ""
		begin
			u = get_townhall_email(i)

		rescue => e

			puts "il y a erreur"

		end

		if u !=""
			print "#{get_townhall_email(i)}   "

			myash.store(nom_pret[t],u)
			options = { :address              => "smtp.gmail.com",
				:port                 => 587,
				:user_name            => '',
				:password             => '',
				:authentication       => 'plain',
				:enable_starttls_auto => true  }

				Mail.defaults do
					delivery_method :smtp, options
				end

				Mail.deliver do
					to '#{get_townhall_email(i)} '
					from 'jose'
					subject 'Test programmation ruby'
					body "Bonjour,
Je m'appelle [PRÉNOM] et je permets de contacter la mairie de [CITY_NAME] à propos du remarquable travail que font Les Restos du Coeur. Cette association répand le bien dans la France et aide les plus démunis à s'en tirer.

Avez-vous pensé à travailler avec eux ? Soutenir Les Restos du Coeur, c'est important pour notre cohésion sociale : rejoignez le mouvement !

Merci à vous"
				end
			end
			t=t+1
	    #puts t

		#if t==10
		# 	break
		# end=end
		
	end
end
end
adresse = Adresse_mail.new
adresse.oise_town_urls
adresse.oise_town_urls