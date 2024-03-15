
class Camera {
    PVector Pos;
    int speed;
    int animTime;
    float shakeStrength;
    
    Camera() {
        Pos = new PVector(0, 0);
        speed = 6;
        animTime = 0;
        shakeStrength = 3;
    }
    
    void draw() {
        if (keyPressed && Play.isAlive) {
            
            if (keys[87]) {if (!Play.getCollision(new PVector(Pos.x,Pos.y - speed))) {Pos.y -= speed;} } 
            if (keys[83]) {if (!Play.getCollision(new PVector(Pos.x,Pos.y + speed))) {Pos.y += speed;} } 
            if (keys[65]) {if (!Play.getCollision(new PVector(Pos.x - speed,Pos.y))) {Pos.x -= speed;} } 
            if (keys[68]) {if (!Play.getCollision(new PVector(Pos.x + speed,Pos.y))) {Pos.x += speed;} } 
            
        }
    }
    
    void screenshake(int time) {
        if (time != 0) {
            animTime = time;
            screenshake();
        }
        
    }
    void screenshake() {
        float moveX = random( -shakeStrength,shakeStrength);
        float moveY = random( -shakeStrength,shakeStrength);
        if (animTime != 0) {
            translate(moveX, moveY);
        }
        if (animTime <= 0) {
            animTime = 0;
            Play.x = width / 2;
            Play.y = height / 2;
        }
        else{
            animTime--;
        }
        
    }
}
