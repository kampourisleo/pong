package pong 

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import rayl "vendor:raylib" 

WHITE :: (rayl.Color){ 255, 255, 255, 255 } 
//INITIAL RECTANGLE CENTER POSITION (rectangle is proportional to screen):
rect_height := f32(rayl.GetScreenHeight())
rect_width := f32(rayl.GetScreenWidth())
main :: proc() { 
        rayl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
        rayl.InitWindow(800, 600, "PONG")
        rayl.SetTargetFPS(60);

        for !rayl.WindowShouldClose() {
                rayl.BeginDrawing()
                rayl.ClearBackground({ 0, 0, 0, 255 })


                rayl.DrawRectangle(0,0,10,10, WHITE)




                rayl.EndDrawing()
        }
}