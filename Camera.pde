
class Camera {
    PVector pos;
    
    Camera() {
        pos = new PVector(0, 0);
    }
    
    void draw() {
        if (keyPressed) {
            if (key == 'w') pos.y -= 5;
            if (key == 's') pos.y += 5;
            if (key == 'a') pos.x -= 5;
            if (key == 'd') pos.x += 5;
        }
    }
}
