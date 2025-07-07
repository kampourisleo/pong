package pong 

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import rayl "vendor:raylib" 

BLACK :: (rayl.Color){ 0, 0, 0, 255 }
WHITE :: (rayl.Color){ 255, 255, 255, 255 } 

Entity_Rectangle :: struct {
  width : f32,
  height : f32,
  color : rayl.Color,
}




main :: proc() { 
        rayl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
        rayl.InitWindow(800, 600, "PONG")
        rayl.SetTargetFPS(60);

        for !rayl.WindowShouldClose() {
                rayl.BeginDrawing()
                rayl.ClearBackground(BLACK)


                rayl.DrawRectangle(0,0,100,10, WHITE)




                rayl.EndDrawing()
        }
}