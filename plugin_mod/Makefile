plugin_mod.so:
	docker build -t plugin-build .
	docker run --name=plugin-build plugin-build
	docker cp plugin-build:/go/src/github.com/solo-io/solo-plugin-mod/plugin_mod.so plugin_mod.so
	docker cp plugin-build:/go/src/github.com/solo-io/solo-plugin-mod/output_mod.txt output_mod.txt
	docker rm -f plugin-build
	docker rmi -f plugin-build