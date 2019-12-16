.PHONY: build-and-serve test

build-and-serve:
	cd assets && yarn install && yarn build
	mix phx.server

test:
	mix test
	cd assets && yarn install && yarn test
