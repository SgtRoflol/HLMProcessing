class Projectile{
    boolean isActive;
    PVector Pos;
    float speed;
    PVector dir;
    Wall[] Walls;
    boolean isHostile;
    PVector Origin;
    
    Projectile(float speed, boolean hostile, PVector Origin, Wall[] Walls) {
        this.speed = speed;
        isHostile = hostile;
        this.Origin = Origin;
        this.Walls = Walls;
        Pos = new PVector();
        dir = new PVector();
        init();
    }
    
    
    void init() {
        isActive = false;
        Pos = Origin;
    }
    
    void spawn(float x, float y) {
        init();
        //Normalisierter Differenzvektor zwischen Position und Ziel wird als
        //Richtung definiert
        PVector Target = new PVector(x,y);
        dir = PVector.sub(Target,Pos);
        dir.normalize();
        dir.mult(speed);
        isActive = true;
    }
    
    void render() {
        ellipseMode(CENTER);
        color curcol = g.fillColor;
        fill(255, 255, 0);
        
        if (isActive) {       
            if (checkCollision()) {
                isActive = false;
            }
            else{
                // Projektil wird in Richtung Ziel verschoben
                Pos = Pos.add(dir);
                ellipse(Pos.x,Pos.y,10,10);   
            } 
            //Farbe wird auf vorherigen Wert zurückgesett
            fill(curcol);
    } }
    
    boolean checkCollision() {
        //Wenn das Projektil ausserhalb des Bildschirms ist
        if (Pos.x > worldCamera.Pos.x + width || Pos.x < worldCamera.Pos.x) {
            return true;
        }    
        if (Pos.y > worldCamera.Pos.y + height || Pos.y < worldCamera.Pos.y) {
            return true;
        }
        
        //Wenn das Projektil eine Wand trifft
        for (Wall Wall : Walls) {
            if (Pos.x + dir.x >= Wall.Pos.x && Pos.x + dir.x <= Wall.Pos.x + Wall.w && 
                Pos.y + dir.y >= Wall.Pos.y && Pos.y + dir.y <= Wall.Pos.y + Wall.h) {
                return true;
            } 
        }
        return false;
    }
    
}
