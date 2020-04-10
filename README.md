# Examples to reproduce Go Plugin compatibility issues
This repo contains scripts to reproduce the compatibility issues we encountered when working with Go Plugins.
It serves mainly as a simple example that everyone on the team can use to understand the problem.

## Building the example artifacts
We create a Go plugin and Go application that loads the plugin. Both the plugin and the application share the
same version of the `gopkg.in/yaml.v2` dependency.

We build both the plugin and the application:
- once in "module-aware mode": the `go` command requires the use of modules, never consulting `GOPATH`;
- once in "GOPATH mode" (GO111MODULE=off): the `go` command never uses module support; 
instead it looks in vendor directories and `GOPATH` to find dependencies.

We end up with 4 artifacts, which are reflected in the 4 directories in the repo root.

We build (and run) all of the above artifacts inside linux docker containers, so we:
- have a reproducible build environment
- don't run into cross-compilation problems, since we need to enable CGO
- mimic the way we build the binaries that have been affected by these compatibility issues

When building in **GOPATH mode**, we run `go mod vendor` to fetch all the dependencies and then copy them into the `GOPATH` 
inside the container. We do this to mimic what we do 
[here](https://github.com/solo-io/ext-auth-plugin-examples/blob/2a7e2dffe5d7889a6e07130ab0d7a02d37a2db7b/Dockerfile#L35).

## Testing scenarios
The Makefile contains 4 test:
- `make vendor-loader-vendor-plugin`: loads a plugin built in **GOPATH mode** with a loader built in **GOPATH mode**. 
This will **succeed**.
- `make mod-loader-mod-plugin`: loads a plugin built in **module-aware mode** with a loader built in **module-aware mode**. 
This will **succeed** as well.
- `make vendor-loader-mod-plugin`: loads a plugin built in **module-aware mode** with a loader built in **GOPATH mode**. 
This will **fail**.
- `make mod-loader-vendor-plugin`: loads a plugin built in **GOPATH mode** with a loader built in **module-aware mode**. 
This will **fail** as well.

## Explanation of the failures
The failures are caused by this error (which we know all too well...):
> plugin was built with a different version of package gopkg.in/yaml.v2

The problem is that when Go compiles a package, the path of the package is part of the package identity. 
Hence, even if the code for two packages is EXACTLY the same, the go runtime will see them as different if they have 
been compiled in different directories.

When we compile in **module-aware mode**, the path of the `gopkg.in/yaml.v2` package is:
``` 
/go/pkg/mod/gopkg.in/yaml.v2@v2.2.8
```

When we compile in **GOPATH mode**, the path of the `gopkg.in/yaml.v2` package is:
``` 
/go/src/gopkg.in/yaml.v2
```

This causes the above error.

You can verify this yourself by:
- inspecting the compiler output we save to `output_mod.txt` files in the plugin directories. 
Search for lines that contain `cd /go/pkg/mod/gopkg.in/yaml.v2@v2.2.8` and `cd /go/src/gopkg.in/yaml.v2`;
- running `strings plugin_vendor.so | grep 'gopkg.in/yaml.v2'` and comparing the output to the one 
of `strings plugin_mod.so | grep 'gopkg.in/yaml.v2'`.