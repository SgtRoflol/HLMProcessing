
class Camera {
    int shiftdist;
    PVector pos;
    
    
    Camera() {
        pos = new PVector(0, 0);
        shiftdist = 20;
    }
    
    void draw() {
        if (keyPressed) {
            if (key == 'w') {if (!Play.getCollision(new PVector(pos.x,pos.y - 5))) {pos.y -= 5;} } 
            if (key == 's') {if (!Play.getCollision(new PVector(pos.x,pos.y + 5))) {pos.y += 5;} } 
            if (key == 'a') {if (!Play.getCollision(new PVector(pos.x - 5,pos.y))) {pos.x -= 5;} } 
            if (key == 'd') {if (!Play.getCollision(new PVector(pos.x + 5,pos.y))) {pos.x += 5;} } 
            
        }
    }
    
}
