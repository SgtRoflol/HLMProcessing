class Projectile{
    boolean isActive;
    PVector Pos;
    float speed;
    PVector dir;
    
    Projectile(float speed) {
        this.speed = speed;
        init();
    }
    
    void init() {
        isActive = false;
        Pos = new PVector(width / 2,height / 2);
        Pos.x = worldCamera.pos.x + width / 2;
        Pos.y = worldCamera.pos.y + height / 2;
        dir = new PVector(0,0);
    }
    
    void spawn() {
        init();
        PVector mouse = new PVector(worldCamera.pos.x + mouseX,worldCamera.pos.y + mouseY);
        dir = PVector.sub(mouse,Pos);
        dir.normalize();
        dir.mult(speed);
        isActive = true;
        Pos.x = worldCamera.pos.x + width / 2;
        Pos.y = worldCamera.pos.y + height / 2;
    }
    
    void render() {
        ellipseMode(CENTER);
        color curcol = g.fillColor;
        fill(255, 255, 0);
        if (isActive) {
            checkBounds();
            Pos = Pos.add(dir);
            ellipse(Pos.x,Pos.y,10,10);
        }
        else{
            Pos.x = worldCamera.pos.x + width / 2;
            Pos.y = worldCamera.pos.y + height / 2;
            ellipse(Pos.x,Pos.y,10,10);
        }
        fill(curcol);
    }
    
    void checkBounds() {
        if (Pos.x > worldCamera.pos.x + width || Pos.x < worldCamera.pos.x) {
            init();
        }
        
        if (Pos.y > worldCamera.pos.y + height || Pos.y < worldCamera.pos.y) {
            init();
        }
    }
    
}
