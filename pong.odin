package pong 
//------------------------------------------
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
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
}
Entity_Ball :: struct { 
        radius : i32, 
        center_pos : i32,
        velocity_x : i32, // value: 1 or -1
        velocity_y : i32, // value: 1 or -1
}
//------------------------------------------
main :: proc() { 
        //INITIAL WINDOW SETUP
        screenH : i32 = 600 //rayl.GetScreenHeight()
        screenW : i32 = 800 //rayl.GetScreenWidth()
        rayl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
        rayl.InitWindow(screenW, screenH, "PONG")
        rayl.SetTargetFPS(60);
        //RECTANGLE DEFINITION
        Rectangle : Entity_Rectangle
        Rectangle.width = screenW/8
        Rectangle.height = screenH/60
        Rectangle.color = RED
        pos : i32 = 500 //{values from 0 to (screenW-Rectangle.width)}
        //RUNTIME
        for !rayl.WindowShouldClose() {
                rayl.BeginDrawing()
                rayl.ClearBackground(BLACK) //BACKGROUND COLOR
                if pos+Rectangle.height <= screenW-Rectangle.width {
                        if rayl.IsKeyDown(rayl.KeyboardKey.RIGHT) do pos = pos+Rectangle.height
                }
                if pos-Rectangle.height >= 0 {
                        if rayl.IsKeyDown(rayl.KeyboardKey.LEFT) do pos = pos-Rectangle.height
                }


                        rayl.DrawRectangle(pos, (screenH-Rectangle.height), Rectangle.width, Rectangle.height, Rectangle.color)




                rayl.EndDrawing()
        }
}