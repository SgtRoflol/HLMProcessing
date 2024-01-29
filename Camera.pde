
class Camera {
    int shiftdist;
    PVector Pos;
    
    
    Camera() {
        Pos = new PVector(0, 0);
        shiftdist = 20;
    }
    
    void draw() {
        if (keyPressed) {
            if (key == 'w') {if (!Play.getCollision(new PVector(Pos.x,Pos.y - 5))) {Pos.y -= 5;} } 
            if (key == 's') {if (!Play.getCollision(new PVector(Pos.x,Pos.y + 5))) {Pos.y += 5;} } 
            if (key == 'a') {if (!Play.getCollision(new PVector(Pos.x - 5,Pos.y))) {Pos.x -= 5;} } 
            if (key == 'd') {if (!Play.getCollision(new PVector(Pos.x + 5,Pos.y))) {Pos.x += 5;} } 
            
        }
    }
    
}
