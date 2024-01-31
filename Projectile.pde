class Projectile{
    boolean isActive;
    PVector Pos;
    float speed;
    PVector dir;
    Wall[] Walls;
    boolean isHostile;
    PVector Origin;
    int damage;
    
    Projectile(float speed, boolean hostile, PVector Origin, Wall[] Walls, int damage) {
        this.speed = speed;
        isHostile = hostile;
        this.Origin = Origin;
        this.Walls = Walls;
        Pos = new PVector();
        dir = new PVector();
        this.damage = damage;
        init();
    }
    
    void setWalls(Wall[] Walls) {
        this.Walls = Walls;
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
        if (!isOnScreen()) {
            isActive = false;
        }
        else if (isActive) {       
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
    
    boolean isOnScreen() {
        //Wenn das Projektil ausserhalb des Bildschirms ist
        if (Pos.x > worldCamera.Pos.x + width || Pos.x < worldCamera.Pos.x) {
            return false;
        }    
        if (Pos.y > worldCamera.Pos.y + height || Pos.y < worldCamera.Pos.y) {
            return false;
        }
        return true;
    }
    
    boolean checkCollision() {
        //Wenn das Projektil eine Wand trifft
        for (Wall Wall : Walls) {
            if (Wall.isOnScreen()) { 
                if (Pos.x + dir.x >= Wall.Pos.x && Pos.x + dir.x <= Wall.Pos.x + Wall.w && 
                    Pos.y + dir.y >= Wall.Pos.y && Pos.y + dir.y <= Wall.Pos.y + Wall.h) {
                    return true;
                } 
            }
        }
        return false;
    }
}
