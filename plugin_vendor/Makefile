plugin_vendor.so:
	go mod vendor
	docker build -t plugin-build .
	docker run --name=plugin-build plugin-build
	docker cp plugin-build:/go/src/github.com/solo-io/solo-plugin-vendor/plugin_vendor.so plugin_vendor.so
	docker cp plugin-build:/go/src/github.com/solo-io/solo-plugin-vendor/output_vendor.txt output_vendor.txt
	docker rm -f plugin-build
	docker rmi -f plugin-build