build-and-serve:
	cd assets && yarn install && build
	mix phx.server
