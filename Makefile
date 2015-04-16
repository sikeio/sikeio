.PHONY: migrate
migrate:
	rake db:migrate
	annotate app/models/*.rb