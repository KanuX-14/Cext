Cext game engine
===================
	
Version 0.1

Written in Pure C, SDL and OpenGL.

This engine will be used as the base of the games I will create. Thank you so much, [Corange](https://github.com/orangeduck/Corange)!.

Running
-------
	
Cext is a library, but to take a quick look at some of the things it does you can [Look at some of the Demos](http://www.youtube.com/watch?v=482GxqTWXtA). Warning: Some things shown are from a previous version and may not remain the same in this version.
	

Compiling
---------
	
To compile on Windows you need MinGW and then you should be able to run "make" as usual. You will need to have installed SDL, SDL_Mixer and SDL_Net.
```sh
  make -j2 && make install_win32
```

To compile on Linux you need to install SDL2. Then you should run "make".
```sh
  sudo apt-get install libsdl2-dev
  sudo apt-get install libsdl2-mixer-dev
  sudo apt-get install libsdl2-net-dev
  make -j2 && sudo make install_unix
```


Overview
--------

* Small, Simple, Powerful, Cross platform
* Clean and easy Asset, UI, Entity management
* Modern Deferred renderer


Demos
-----

I'm a graphics programmer by trade so apologies that most of the demos are graphical apps; they're just what I love!

* __renderers__ Shows off the various renderers with shaders, shadows, animation etc.
* __metaballs__ Uses OpenCL/OpenGL interop to do Metaball rendering.
* __noise__ Feedback based noise pattern on screen using shader. Can generate tileable perlin noise in software.
* __platformer__ Basic platforming game. Fairly well commented.
* __sea__ Renders a sea-like surface, a ship, and some collision detection.
* __scotland__ Demonstrates terrain system.
* __tessellation__ Demo showing tessellation shaders in OpenGL 4.

  
Using / Contributing
--------------------
	
This is still mainly a personal project and so there are going to be lots of bugs, unfinished features and messy bits of code. The engine is heavily WIP and subject to sweeping changes. It isn't really viable to use without also being part of the project development and in communication with me. Rather than a full game engine like Unity, Cext is more of a framework and gives you access to features at about the same level as XNA.

I have a big backlog of Work in Progress changes I need to push up to the repository once they get to a reasonable point so if you are interested in those please contact me.
		
Saying that, it is a great excuse to practise your C and I very much welcome help. If the project appeals to you here are a couple of quick things that might help get you started.
		
* First take a look at the demos. These give a brief overview of how Cext can be used. The platformer demo is probably the most commented.

* There is no real documentation so your first port of call is the header files and your second is the c files. The code has very minimal comments but should be pretty clear most of the time.

* Cext doesn't hide anything from you. OpenGL and SDL calls are in the namespace so you've got access to the basics. The corange_init and corange_finish functions are fairly short so it is even possible to not call them and only use the components you want.

* Structs are typedefed without their pointer. The reason for this is a personal choice but there are also quite a few data types which are passed by value on the stack (vectors, matrices, spheres, boxes). I didn't want the notion of these to get confused.

* Some important parts of the engine are the asset, UI and entity managers. These basically let you access and store assets (models, textures - objects in the file system) and entities (lights, cameras, engine objects) and UI elements. They clean up memory on destruction and let you get pointers from all parts of the code.

* Cext mangles the namespace pretty badly, taking names such as "error", "warning", "vec2" and "image". It isn't a general purpose library. But I've still tried to decouple stuff so it should be possible to extract certain code if you need it.

