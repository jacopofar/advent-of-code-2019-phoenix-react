build-and-serve:
	cd assets && yarn install && yarn build
	mix phx.server
