class Projectile{
    boolean isActive;
    PVector Pos;
    float speed;
    PVector dir;
    Wall[] Walls;
    boolean isHostile;
    PVector Origin;
    int damage;
    int lifetime;
    PVector Target;
    
    //Konstruktor
    Projectile(float speed, boolean hostile, PVector Origin, Wall[] Walls, int damage) {
        this.speed = speed;
        isHostile = hostile;
        this.Origin = Origin;
        this.Walls = Walls;
        Pos = new PVector();
        dir = new PVector();
        this.damage = damage;
        init();
        lifetime = 0;
    }
    
    //Wände werden gesetzt
    void setWalls(Wall[] Walls) {
        this.Walls = Walls;
    }
    
    //Projektil wird initialisiert
    void init() {
        isActive = false;
        //Position wird auf Ursprung gesetzt
        Pos = Origin;
        lifetime = 0;
    }
    
    void spawn(float x, float y) {
        init();
        //Normalisierter Differenzvektor zwischen Position und Ziel wird als
        //Richtung definiert
        Target = new PVector(x,y);
        dir = PVector.sub(Target,Pos);
        dir.normalize();
        dir.mult(speed);
        isActive = true;
    }
    
    void render() {
        //Wenn das Projektil aktiv ist und feindlich, wird die Lebenszeit erhöht
        if (!isHostile && isActive) {
            lifetime++;
        {
                //Wenn die Lebenszeit 200 erreicht, wird das Projektil zurückgesetzt
                if (lifetime >= 200) {
                    init();
                    return;
                }
            }
        }
        
        color curcol = g.fillColor;
        fill(255, 255, 0);
        //Wenn das Projektil ausserhalb des Bildschirms ist, wird es deaktiviert
        if (!isOnScreen()) {
            isActive = false;
        }
        
        else if (isActive) {       
            //Wenn das Projektil eine Wand trifft, wird es deaktiviert
            if (checkCollision()) {
                isActive = false;
            }
            else{
                // Projektil wird in Richtung Ziel verschoben
                Pos = Pos.add(dir);
                rectMode(CENTER);
                pushMatrix();
                //Projektil wird in Richtung Ziel gedreht
                float angle = atan2(Pos.x - Target.x, Pos.y - Target.y);
                translate(Pos.x, Pos.y);
                rotate( -angle);
                //Projektil wird gezeichnet
                rect(0, 0, 4,15);   
                popMatrix();   
            } 
            //Farbe wird auf vorherigen Wert zurückgesett
            fill(curcol);
    } }
    
    boolean isOnScreen() {
        if (isHostile) {
            //Wenn das Projektil ausserhalb des Bildschirms ist
            if (Pos.x > worldCamera.Pos.x + width || Pos.x < worldCamera.Pos.x) {
                return false;
            }   
            if (Pos.y > worldCamera.Pos.y + height || Pos.y < worldCamera.Pos.y) {
                return false;
            }
            
        }
        return true;
    }
    
    boolean checkCollision() {
        //Wenn das Projektil eine Wand trifft
        for (Wall Wall : Walls) {
            if (Wall.isOnScreen() || !isHostile) { 
                if (Pos.x + dir.x >= Wall.Pos.x && Pos.x + dir.x <= Wall.Pos.x + Wall.w && 
                    Pos.y + dir.y >= Wall.Pos.y && Pos.y + dir.y <= Wall.Pos.y + Wall.h) {
                    return true;
                } 
            }
        }
        return false;
    }
}
