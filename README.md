For my work, I tend to need a Linux kernel for various architectures
with just the default configuration. Since it takes a while to compile
the Linux kernel even on beefy machines, all this project does is basically
make it easy for me to cache those images.

That's literally it.

## Downloads

See the latest [GitHub release](https://github.com/Ivan-Velickovic/linux_prebuilts/releases/latest).

## Building

```sh
nix build .
```

Or if you want a specific image, e.g:

```sh
nix build .#linux-616-arm64
```
