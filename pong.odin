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
//POLAR-TO-CARTESIAN FOR LCS: bool True -> X, bool False -> Y
polar2cart :: proc(radius : f32, theta : f32, returnX : bool) -> (f32){
        x : f32 = radius * math.cos_f32(theta)
        y : f32 = radius * math.sin_f32(theta) 
        if returnX {
                return x
        }
        else {
                return y
        }
}
//LCS to GCS TRANSFORM WITHOUT ROTATIONS: MODIFY FOR MATRIX INPUT!!!!!!!!!!!
lcs2gcs :: proc(center_x : i32 , center_y : i32, x_lcs : f32, 
                                        y_lcs : f32 ) -> (f32,f32){
        x_gcs : f32 = f32(center_x) + x_lcs
        y_gcs : f32 = f32(center_y) + y_lcs 
        return x_gcs, y_gcs
}
//CIRCLE BOUNDARY CALCULATION (OCTAGON)
circle_boundary :: proc(radius : f32, center_x : i32, 
                center_y : i32) ->(matrix[2,8]f32) {
        boundary_ball : matrix[2, 8] f32 //for every 45 degrees
                for i := 0; i < 8; i += 1 {
                    boundary_ball[0,i] = polar2cart(radius, f32(i*45), true) //THIS IS X
                    boundary_ball[0,i] = boundary_ball[0,i] + f32(center_x)
                    boundary_ball[1,i] = polar2cart(radius, f32(i*45), false) //THIS IS Y
                    boundary_ball[1,i] = boundary_ball[1,i] + f32(center_y)
                }     

        return  boundary_ball
}
//PADDLE - RECTANGLE BOUNDARY CALCULATION: UNDER CONSTRUCTION
paddle_boundary :: proc(pos : i32, width : i32,
 height : i32, ScreenHeight : i32) -> ([16]f32) { 
        //Y_out := ScreenHeight - height
        boundary_rectangle : [16]f32 //X only because Y :: ScreenHeight-height
        for i := 0; i < 16; i += 1 {
        boundary_rectangle[i] = f32(pos + (i32(i)*width/15))
        }
        return boundary_rectangle
 }        
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
        Rectangle.width = screenW/8
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
        Ball.colliders = circle_boundary(Ball.radius, Ball.center_x, Ball.center_y)

        //MAIN
        for !rayl.WindowShouldClose() {
                rayl.BeginDrawing()
                rayl.ClearBackground(BLACK) //BACKGROUND COLOR
                ft = rayl.GetFrameTime(); //TIME ELAPSED BETWEEN 2 FRAMES
                //--------------------------
                        rayl.DrawCircle(Ball.center_x, Ball.center_y, Ball.radius, Ball.color);
                        //MAKE DIFFICULTIES +4,5,6
                        Ball.center_x = Ball.center_x + 6*Ball.velocity_x
                        Ball.center_y = Ball.center_y + 6*Ball.velocity_y 
                //-------------------------
                        //COLLISION CHECK:
                        for i := 0; i < 8; i += 1 {
                                for j := 0; j < 16; j += 1 {
                                        //if condition do 
                                }
                        }
                //-------------------------
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