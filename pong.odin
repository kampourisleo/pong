package pong 
//------------------------------------------
import "core:fmt"
import "core:os" 
import "core:math"
import rayl "vendor:raylib" 
//RAYLIB COLORS
BLACK :: (rayl.Color){ 0, 0, 0, 255 }
WHITE :: (rayl.Color){ 255, 255, 255, 255 } 
SKYBLUE :: (rayl.Color){ 102, 191, 255, 255 } 
RED :: (rayl.Color){ 230, 41, 55, 255 }
//------------------------------------------
Entity_Rectangle :: struct {
        width : i32,
        height : i32,
        color : rayl.Color,
        colliders : [16]f32
}
Entity_Ball :: struct { 
        radius : f32, 
        center_x : i32,
        center_y : i32,
        velocity_x : i32, // value: 1 or -1
        velocity_y : i32, // value: 1 or -1 
        color : rayl.Color, 
        colliders : matrix[2,8]f32 //octagon
}
//------------------------------------------
main :: proc() { 
        //INITIAL WINDOW SETUP
        screenH : i32 = 600 //rayl.GetScreenHeight()
        screenW : i32 = 800 //rayl.GetScreenWidth()
        ft : f32 = 0
        rayl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
        rayl.InitWindow(screenW, screenH, "PONG")
        rayl.SetTargetFPS(60);                   
        //RECTANGLE DEFINITION
        Rectangle : Entity_Rectangle
        Rectangle.width = screenW/6
        Rectangle.height = screenH/60
        Rectangle.color = RED
        pos : i32 = 500 //{values from 0 to (screenW-Rectangle.width)} 
        //BALL DEFINITION 
        Ball : Entity_Ball
        Ball.radius = 10.0
        Ball.center_x = 200 
        Ball.center_y = 200 
        Ball.color = SKYBLUE
        Ball.velocity_x = 1 //or -1
        Ball.velocity_y = 1 //or -1 
                //MAIN
                for !rayl.WindowShouldClose() {
                rayl.BeginDrawing()
                rayl.ClearBackground(BLACK) //BACKGROUND COLOR
                ft = rayl.GetFrameTime(); //TIME ELAPSED BETWEEN 2 FRAMES
                //--------------------------
                        rayl.DrawCircle(Ball.center_x, Ball.center_y, Ball.radius, Ball.color);
                        //DIFFICULTIES +4,5,6 (change factor before velocity)
                        Ball.center_x = Ball.center_x + 6*Ball.velocity_x
                        Ball.center_y = Ball.center_y + 6*Ball.velocity_y 
                        //COLLISION CHECKS:
                        if (Ball.center_x <= pos+Rectangle.width) && (Ball.center_y+i32(Ball.radius) == screenH) && (Ball.center_x >= pos)  {
                                Ball.velocity_y = -1  
                                if rayl.IsKeyDown(rayl.KeyboardKey.RIGHT) do Ball.velocity_x = 1
                                if rayl.IsKeyDown(rayl.KeyboardKey.LEFT) do Ball.velocity_x = -1
                        }
                        if (Ball.center_x < i32(Ball.radius)) do Ball.velocity_x = 1 
                        if (Ball.center_x > i32(screenW-i32(Ball.radius))) do Ball.velocity_x = -1 
                        if (i32(Ball.center_y-i32(Ball.radius)) < 0) do Ball.velocity_y = 1
                        //MOVEMENT:
                        if pos+Rectangle.height <= screenW-Rectangle.width {
                                if rayl.IsKeyDown(rayl.KeyboardKey.RIGHT) do pos = pos+Rectangle.height
                        }
                        if pos-Rectangle.height >= 0 {
                                if rayl.IsKeyDown(rayl.KeyboardKey.LEFT) do pos = pos-Rectangle.height
                        }
                                rayl.DrawRectangle(pos, (screenH-Rectangle.height), Rectangle.width, Rectangle.height, Rectangle.color)
                                rayl.DrawCircle(Ball.center_x, Ball.center_y, Ball.radius, Ball.color);  
                        rayl.EndDrawing()
                }
}