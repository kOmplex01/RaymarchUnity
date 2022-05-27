# Raymarch Unity
In this project, I have tried out Raymarching, which is a technique to render any objects without any polygon & Triangles if we can find out the ****Signed Distance Function**** of that object.

![image](https://user-images.githubusercontent.com/98254989/170685433-830c3908-ae23-433b-a24f-f1685d1e1254.png)

## Features Defined
![image](https://user-images.githubusercontent.com/98254989/170683738-18303f32-e2ef-4ab5-acbb-26f8298d6193.png)
Try to tweak the values to observe the changes

## Adding Color to the Shader
![image](https://user-images.githubusercontent.com/98254989/170683860-60d1aafa-b9d0-4177-a70e-7168cb22ecd6.png)
```
col = d      // White
col.r = d    // Red
col.g = d    // Green
col.b = d    // Blue
col.rg = d   // Yellow
col.rg = d   // Yellow
col.gb = d   // Cyan
col.rb = d   // Magenta
```

## About the Scene
This project is highly efficient as all the calculation is handled by GPU in the runtime.
Also, the scene only contain a canvas with just a **Raw Image** covering the entire screen with the camera set to render on the canvas. As you can see in the video, the Raw Image is moving with the camera, nothing else.

At each frame, a ray is casted to find the collision using **Raymarching Algorithm**, using current camera world position and its orientation (Direction the camera is facing), and calculate collision at runtime.

## Different Shaders

#### Infinity Sphere Shader
https://user-images.githubusercontent.com/98254989/170684719-ceef561b-e943-4221-9c4f-6c60e6e2cd22.mp4

#### Infinity Way Shader
https://user-images.githubusercontent.com/98254989/170684771-723981f3-39f9-438a-8a10-4ed2a72ffeba.mp4

#### Mandelbulb Shader (My Personal Favourite)
https://user-images.githubusercontent.com/98254989/170684819-28612c87-12e7-41ee-859a-96ab454150b1.mp4

In this shader, you can use the power slider to see the mandelbulb forming, but if you want it to happen with time
```
power = _Time * k;

_Time : Already unity defined variable 
k : any constant to adjust the speed of mandelbulb
```
