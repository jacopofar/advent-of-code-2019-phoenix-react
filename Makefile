build-and-serve:
	cd assets && yarn build
	mix phx.server
