.PHONY: build-and-serve test

build-and-serve:
	cd assets && yarn install && yarn build
	mix do deps.get, deps.compile
	mix phx.server
	# here should go dialyzer, but it's just too slow for any practical CI :/

test:
	mix test
	cd assets && yarn install && yarn test

dialyze:
	mix dialyzer
