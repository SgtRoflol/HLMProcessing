
class Camera {
    PVector Pos;
    int speed;
    
    Camera() {
        Pos = new PVector(0, 0);
        speed = 6;
    }
    
    void draw() {
        if (keyPressed && Play.isAlive) {
            
            if (keys[87]) {if (!Play.getCollision(new PVector(Pos.x,Pos.y - speed))) {Pos.y -= speed;} } 
            if (keys[83]) {if (!Play.getCollision(new PVector(Pos.x,Pos.y + speed))) {Pos.y += speed;} } 
            if (keys[65]) {if (!Play.getCollision(new PVector(Pos.x - speed,Pos.y))) {Pos.x -= speed;} } 
            if (keys[68]) {if (!Play.getCollision(new PVector(Pos.x + speed,Pos.y))) {Pos.x += speed;} } 
            
        }
    }
    
}
