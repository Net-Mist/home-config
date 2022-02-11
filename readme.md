# Personal home manager

This repo contains Nix code used to quickly deploy my environment on several computers. Tested on Linux, maybe works on Mac

## code organisation

Main entrypoint called by home-manager is `home.nix`.

- config files in `config` dir will be copied in home, following instruction at the end of `home.nix`
- config files in `config_secret` dir will be handle the same way than those in `config`, but are not commited
- custom nix packages are in `custom_pkgs`, with the exception of python
- python package is an exception, as it can become quite big because of all python packages that need to be managed. 
    the main python package is in `python/default.nix` and custom python packages are in `python`
- `libgl` folder contains the custom `libGLX_nvidia.so.0` file. See below the the explanations
- `gl_stuff.nix` contains the nix expression to wrap program that need to use system openGL (the custom `libgl/libGLX_nvidia.so.0` file)


## installation
- Follow [home manager documentation](https://nix-community.github.io/home-manager/index.html#sec-install-standalone)
- create a symlink from this project to `~/.config/nixpkgs`
- fill the missing configuration in config_secret
- generate the custom libgl file
- run `home-manager switch` to update the configuration

## config_secret
for now two config files are not commited: `gitconfig-private` and `gitconfig-work`

both are simple file on the form:
```
[user]
	email = ******
	name = **** ****
	signingkey = ******
[core]
	sshCommand = ssh -i ~/.ssh/id_rsa_********
```

## libGLX_nvidia.so.0

the quick way to generate the file is to run
```sh
cd libgl
cp /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.0 .
patchelf --set-rpath /lib:/usr/lib:/lib64:/usr/lib64:/usr/lib/x86_64-linux-gnu libGLX_nvidia.so.0
```

The longer explanation is:

Several Nix packages need libGL. Because of the way NVIDIA packages it, they need to use the system libGL, not the Nix one.
This can be seen by looking at the system trace of a program crashing because of a libGL problem. For instance, with Blender,
starting the Nix one on a Ubuntu machine gives these logs:
```
intern/ghost/intern/GHOST_WindowX11.cpp:206: X11 glXChooseVisual() failed, verify working openGL system!
initial window could not find the GLX extension
Writing: /tmp/blender.crash.txt
[1]    190094 segmentation fault  blender
```

But running `strace blender` gives more info, we can see at the end
```
openat(AT_FDCWD, "/nix/store/avqk9invc40jg7sh57y0nmpnccz5nm1d-libX11-1.7.2/lib/libGLX_nvidia.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/fi0g7ras1220ynva8jg0rw9msjn6ylpl-libXext-1.3.4/lib/libGLX_nvidia.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/q7x6kz3ziv6r7qylljpb3ml1frq87b69-libglvnd-1.4.0/lib/libGLX_nvidia.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/saw6nkqqqfx5xm1h5cpk7gxnxmw9wk47-glibc-2.33-62/lib/libGLX_nvidia.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/saw6nkqqqfx5xm1h5cpk7gxnxmw9wk47-glibc-2.33-62/lib/libGLX_nvidia.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/avqk9invc40jg7sh57y0nmpnccz5nm1d-libX11-1.7.2/lib/libGLX_indirect.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/fi0g7ras1220ynva8jg0rw9msjn6ylpl-libXext-1.3.4/lib/libGLX_indirect.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/q7x6kz3ziv6r7qylljpb3ml1frq87b69-libglvnd-1.4.0/lib/libGLX_indirect.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/saw6nkqqqfx5xm1h5cpk7gxnxmw9wk47-glibc-2.33-62/lib/libGLX_indirect.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/nix/store/saw6nkqqqfx5xm1h5cpk7gxnxmw9wk47-glibc-2.33-62/lib/libGLX_indirect.so.0", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
```

so Blender is clearly searching for a `libGLX_nvidia.so.0` library. To give him this lib and not all the other system lib, the solution chosen here is to copy this lib to the `./libgl` location, edit it's elf so it can still find it's dependences and wrap the nix program that need the lib to add a `LD_LIBRARY_PATH` in front of the command. 

## add the applications in the gnome menu (or make it findable by lot of desktop env)
```sh
cd ~/.local/share/applications/nix
ln -s $HOME/.nix-profile/share/applications nix
```

## set the default terminal to terminology
```sh
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $HOME/.nix-profile/bin/terminology 50
sudo update-alternatives --config x-terminal-emulator
```

## set up consolefonts and fonts

```sh
cd ~/.local/share/fonts
ln -s $HOME/.nix-profile/share/fonts nix

cd ~/.local/share/consolefonts
ln -s $HOME/.nix-profile/share/consolefonts nix
```

## TODO
[] set up icons
[] set up CUDA
