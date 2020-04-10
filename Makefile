#------------------------------------------------------------------
# Compatibility tests
#------------------------------------------------------------------

# This will SUCCEED
.PHONY: vendor-loader-vendor-plugin
vendor-loader-vendor-plugin: build-loader-vendor plugin_vendor.so
	docker run -v $(shell pwd)/plugin_vendor.so:/plugin_vendor.so plugin-loader-vendor /plugin_vendor.so

# This will SUCCEED
.PHONY: mod-loader-mod-plugin
mod-loader-mod-plugin: build-loader-mod plugin_mod.so
	docker run -v $(shell pwd)/plugin_mod.so:/plugin_mod.so plugin-loader-mod /plugin_mod.so

# This will FAIL
.PHONY: vendor-loader-mod-plugin
vendor-loader-mod-plugin: build-loader-vendor plugin_mod.so
	docker run -v $(shell pwd)/plugin_mod.so:/plugin_mod.so plugin-loader-vendor /plugin_mod.so

# This will FAIL
.PHONY: mod-loader-vendor-plugin
mod-loader-vendor-plugin: build-loader-mod plugin_vendor.so
	docker run -v $(shell pwd)/plugin_vendor.so:/plugin_vendor.so plugin-loader-mod /plugin_vendor.so

#------------------------------------------------------------------
# Build plugins and loaders
#------------------------------------------------------------------

.PHONY: build-loader-mod
build-loader-mod:
	cd loader_mod && $(MAKE)

.PHONY: build-loader-vendor
build-loader-vendor:
	cd loader_vendor && $(MAKE)

plugin_vendor.so:
	cd plugin_vendor && $(MAKE)
	cp plugin_vendor/$@ $@

plugin_mod.so:
	cd plugin_mod && $(MAKE)
	cp plugin_mod/$@ $@

#------------------------------------------------------------------
# Clean
#------------------------------------------------------------------
.PHONY: clean
clean:
	find . -name "*.so" -type f -delete
	find . -name "*.txt" -type f -delete