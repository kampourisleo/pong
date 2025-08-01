package pong 
import "core:fmt"
import "core:os" 
import "core:strconv"
import "core:strings"
import rayl "vendor:raylib" 
//RAYLIB COLORS:
BLACK :: (rayl.Color){ 0, 0, 0, 255 }
WHITE :: (rayl.Color){ 255, 255, 255, 255 } 
SKYBLUE :: (rayl.Color){ 0, 121, 241, 255 }  
PINK :: (rayl.Color){ 255, 40, 190, 255 }
WIN_SCORE :: 60 //victory score (60 is a good baseline)
//STRUCTS FOR ENTITIES:
Entity_Rectangle :: struct {
        width : i32,
        height : i32,
        color : rayl.Color
}
Entity_Ball :: struct { 
        radius : f32, 
        center_x : i32,
        center_y : i32,
        velocity_x : i32, // value: 1 or -1
        velocity_y : i32, // value: 1 or -1 
        color : rayl.Color 
}
//RESTART GAME BUTTON:
restart_game :: proc(screen_width : i32, screen_height : i32, width : i32, 
height : i32, color : rayl.Color) { 
        rayl.DrawRectangle(((screen_width/2)-(width/2)), (height), width, height, color)
}
//MAIN:
main :: proc() { 
        //INITIAL WINDOW SETUP
        scoreCounter := 0 
        livesCounter := 3 //inital lives 
        giveExtra := 0 //used to give extra life after some touches 
        difficulty : i32 = 8 //affects ball speed => higher = faster
        screenH : i32 = 600
        screenW : i32 = 800
        rayl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
        rayl.InitWindow(screenW, screenH, "PONG by Leo") 
        rayl.SetTargetFPS(60);              
        texture := rayl.LoadTexture("round_cat.png")      
        //RECTANGLE DEFINITION
        Rectangle : Entity_Rectangle
        Rectangle.width = screenW/6
        Rectangle.height = screenH/60
        Rectangle.color = PINK
        //BALL DEFINITION 
        Ball : Entity_Ball
        Ball.radius = 10.0
        Ball.center_x = 200 
        Ball.center_y = 200
        Ball.color = WHITE
        Ball.velocity_x = 1 //or -1
        Ball.velocity_y = 1 //or -1 
        //RESTART BUTTON DEFINITION 
        restart_width := 2*Rectangle.width
        restart_height := 5*Rectangle.height 
        //INITIAL BALL POSITION 
        pos : i32 = 500 //INITIAL POSITION: {values from 0 to (screenW-Rectangle.width)}
                //WHILE WINDOW:
                for !rayl.WindowShouldClose() {
                rayl.BeginDrawing()
                rayl.ClearBackground(BLACK) //BACKGROUND COLOR 
                //--------------------------
                        //Losing - Winning Check:  
                        mouse_x := rayl.GetMouseX() 
                        mouse_y := rayl.GetMouseY()
                        if (livesCounter == 0 || scoreCounter == WIN_SCORE) {
                                if livesCounter == 0 do rayl.DrawText("GAME OVER!", i32((screenW/3-screenW/7)), i32(screenH/3), (screenW/10), PINK); 
                                if scoreCounter == WIN_SCORE do rayl.DrawText("YOU WIN!", i32((screenW/2)-(screenW/5)), i32(screenH/3), (screenW/10), PINK); 
                                Ball.center_x = 20000
                                Ball.center_y = 20000 
                                Ball.velocity_x = 0
                                Ball.velocity_y = 0
                                difficulty = 8 
                                //Restart Game Button:
                                restart_game(screenW, Rectangle.height, restart_width, restart_height, SKYBLUE)
                                if ((mouse_x <= (screenW/2 + Rectangle.width)) && 
                                (rayl.IsMouseButtonPressed(rayl.MouseButton.LEFT)) &&
                                 (mouse_x >= (screenW/2 - Rectangle.width)) && 
                                 (mouse_y >= Rectangle.height + restart_height) && (mouse_y <= 2 * restart_height)) || (rayl.IsKeyPressed(rayl.KeyboardKey.ENTER)) {
                                        livesCounter = 4 
                                        scoreCounter = 0
                                } 
                                rayl.DrawText("TRY AGAIN.", screenW/2 - restart_width/3, restart_height+Rectangle.height, 30, BLACK); 
                        }
                        //BALL SPEED:
                        Ball.center_x = Ball.center_x + difficulty*Ball.velocity_x
                        Ball.center_y = Ball.center_y + difficulty*Ball.velocity_y 
                        //COLLISION CHECKS:
                        //for the paddle - upper: (adds score)
                        if (Ball.center_x <= pos+Rectangle.width) && (Ball.center_y+i32(Ball.radius) >= screenH-Rectangle.height) && (Ball.center_x >= pos)  {
                                Ball.velocity_y = -1  
                                scoreCounter += 1
                                giveExtra += 1
                                if giveExtra == 5 {    //change number here for frequency of given lives
                                        livesCounter += 1 
                                        difficulty +=1
                                        giveExtra = 0
                                }
                                if rayl.IsKeyDown(rayl.KeyboardKey.RIGHT) && Ball.velocity_x == 1 do Ball.velocity_x = 2*Ball.velocity_x
                                if rayl.IsKeyDown(rayl.KeyboardKey.LEFT) && Ball.velocity_x == -1 do Ball.velocity_x = 2*Ball.velocity_x
                        } 
                        //for the walls:
                        if (Ball.center_x < i32(Ball.radius)) do Ball.velocity_x = 1 
                        if (Ball.center_x > i32(screenW-i32(Ball.radius))) do Ball.velocity_x = -1 
                        if (i32(Ball.center_y-i32(Ball.radius)) < 0) do Ball.velocity_y = 1
                        //MOVEMENT:
                        if pos <= screenW-Rectangle.width {
                                if rayl.IsKeyDown(rayl.KeyboardKey.RIGHT) || rayl.IsKeyDown(rayl.KeyboardKey.D) do pos = pos+Rectangle.height
                                if (rayl.IsKeyDown(rayl.KeyboardKey.RIGHT) || rayl.IsKeyDown(rayl.KeyboardKey.D)) && rayl.IsKeyDown(rayl.KeyboardKey.SPACE) do pos = pos+2*Rectangle.height
                        }
                        if pos-Rectangle.height >= 0 {
                                if rayl.IsKeyDown(rayl.KeyboardKey.LEFT) || rayl.IsKeyDown(rayl.KeyboardKey.A) do pos = pos-Rectangle.height 
                                if (rayl.IsKeyDown(rayl.KeyboardKey.LEFT) || rayl.IsKeyDown(rayl.KeyboardKey.A)) && rayl.IsKeyDown(rayl.KeyboardKey.SPACE) do pos = pos-2*Rectangle.height

                        }
                        //Drawing Ball and Paddle:
                                rayl.DrawRectangle(pos, (screenH-Rectangle.height), Rectangle.width, Rectangle.height, Rectangle.color)
                                //rayl.DrawCircle(Ball.center_x, Ball.center_y, Ball.radius, Ball.color); 
                                rayl.DrawTexture(texture, Ball.center_x-i32(Ball.radius), Ball.center_y-i32(Ball.radius), WHITE);
                        //Show Score counter: 
                                buf: [8]byte
                                strconv.itoa(buf[:],scoreCounter)
                                score := strings.clone_to_cstring(strings.concatenate({"SCORE: ", string(buf[:])})) 
                                rayl.DrawText(score, 10, 10, 18, WHITE);
                        //Show Lives counter: 
                                buf1 : [8]byte
                                strconv.itoa(buf1[:],livesCounter) 
                                lives := strings.clone_to_cstring(strings.concatenate({"LIVES: ", string(buf1[:])}))
                                rayl.DrawText(lives, screenW-(screenW/8), 10, 18, WHITE) 
                        //Show Winning score: 
                                buf2 : [8]byte 
                                strconv.itoa(buf2[:], WIN_SCORE)
                                win_score := strings.clone_to_cstring(strings.concatenate({"SCORE TO WIN: ", string(buf2[:])})) 
                                rayl.DrawText(win_score, (screenW/2 - screenH/8), 10, 18, SKYBLUE)
                        //Respawn:
                        if (i32(Ball.center_y-i32(Ball.radius)) > screenH) && (livesCounter != 0) && (scoreCounter != WIN_SCORE) {
                                Ball.center_x = rayl.GetRandomValue(i32(Ball.radius), screenW-i32(Ball.radius))
                                Ball.center_y = 100 
                                Ball.velocity_x = 1
                                Ball.velocity_y = 1
                                livesCounter = livesCounter - 1
                        } 
                        rayl.EndDrawing() 
                } 
}