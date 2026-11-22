# agnostep-apps-manager
A wizard to fetch, build and install GNUstep applications on every computer powered by [agnostep-desktop](../../../agnostep-desktop).

> [!CAUTION]
> This repo is in early stage. Do NOT use before this note will be removed.

## Install

```console
cd ~/SOURCES
git clone --recursive https://github.com/pcardona34/agnostep-apps-manager
```

## Update

```console
cd ~/SOURCES/agnostep-apps-manager
git submodule update --remote
git pull
```

## Using

To install a GNUstep application:

```
cd ~/SOURCES/agnostep-apps-manager
bash ./agnostep.sh
```

Then, from the dialog:
1. Choose a category
2. Choose an application.
3. Read the long info about the selected application.
4. Confirm the installation.

The all will be automated: fetching the source, building and installing.

> ![WARNING]
> To perform an installation, you will need to become a superuser: `sudo` will ask your password.

> ![NOTE]
> The GNUstep AgnostepManager UI of the previous release is not yet available for the 3rd release of Agnostep. It will come soon. 

## How to reset DEBUG status

Edit `AGNOSTEP.conf` and change `DEBUG` value to `YES` or `NO`.

## How to avoid Splash screen

Execute:

```console
export SPLASH=NO && bash ./agnostep.sh
```

## How to test and submit a new application

1. Duplicate `Template` folder in `MODULES/test`
2. Name this copy with you Appname.
3. Edit `APPINFO.ini`, `DEPS.ini` and `install.sh`. If needed, create `dep_yourapp_debian_13.txt`.
4. Run Agnostep Apps Manager and choose `test` category, then your app...

When you are satisfied, remove the `build` folder and copy this new App folder to its category target (NOT  in `agnostep-apps-manager`, but in the target module fork, outside this repo) and submit a PR.
