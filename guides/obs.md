# Recording with OBS

## Quick and dirty

Works just fine.

## with pipewire

Works just fine.

## JACK

Start JACK first, just in case.

Open OBS. In sources, click `+` -> JACK Input Client -> Choose name. Select 2 input channels, if asked.

![](/img/0-obs.webp)

I recommend to disable any other system audio in OBS: Settings -> Audio -> Global Audio devices -> disable any "Desktop Audio". They created white noise on my system.

![](/img/2-obs.webp)

Start the game and open a patchbay once it's running. It will look something like this:

![](/img/1-catia.webp)

* `Pulse Audio JACK [...]` is from `pulseaudio-jack` (which is pretty nice to have, but not needed to get the game running)
* `system` are the input and output devices
* `JACK Input Client` is the sink from OBS we just created
* `Rocksmith2014` is the game

Now tie Rocksmith's outputs to OBS's inputs. OBS should get sound from Rocksmith now.

Have fun recording and/or streaming.
