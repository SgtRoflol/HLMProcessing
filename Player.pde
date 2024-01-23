class Player{
    float angle;
    float x;
    float y;
    color farbe;
    
    Player() {
        x = width / 2;
        y = height / 2;
        farbe = color(255,0,0,10);
    }
    
    void render() {
        color curcol = g.fillColor;
        fill(farbe);
        rectMode(CENTER);
        rect(0,0,50,50);
        fill(curcol);
    }
    
    
    void move() {
        pushMatrix();
        angle = atan2(x - mouseX, y - mouseY);
        translate(x, y);
        rotate( -angle - HALF_PI);
        render();
        popMatrix();
    }
    
}
